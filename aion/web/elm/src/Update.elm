module Update exposing (..)

import Models.Models exposing (Model, Route(..), UserInChannelRecord)
import Msgs exposing (Msg(..))
import Routing exposing (parseLocation)
import Phoenix.Socket
import Phoenix.Channel
import Json.Decode as JD exposing (field)
import Phoenix.Push
import Json.Encode as JE


chatMessageDecoder : JD.Decoder ChatMessage
chatMessageDecoder =
    JD.map ChatMessage
        (field "body" JD.string)


type alias ChatMessage =
    { body : String }


usersListDecoder : JD.Decoder UserList
usersListDecoder =
    JD.map UserList
        (field "users" (JD.list userRecordDecoder))

userRecordDecoder : JD.Decoder UserInChannelRecord
userRecordDecoder =
    JD.map2 UserInChannelRecord
        (field "name" JD.string)
        (field "score" JD.int)


type alias UserList =
    { users : List UserInChannelRecord }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchRooms response ->
            ( { model | rooms = response }, Cmd.none )

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                case newRoute of
                    RoomRoute roomId ->
                        let
                            roomIdToString =
                                toString roomId

                            channel =
                                Phoenix.Channel.init ("rooms:" ++ roomIdToString)

                            ( socket, cmd ) =
                                Phoenix.Socket.join channel (model.socket |> Phoenix.Socket.on "user:list" ("rooms:" ++ roomIdToString) ReceiveUserList)
                        in
                            ( { model | socket = socket, route = newRoute }
                            , Cmd.map PhoenixMsg cmd
                            )

                    _ ->
                        ( { model | route = newRoute }, Cmd.none )

        PhoenixMsg msg ->
            let
                ( socket, cmd ) =
                    Phoenix.Socket.update msg model.socket
            in
                ( { model | socket = socket }
                , Cmd.map PhoenixMsg cmd
                )

        ReceiveUserList raw ->
            case JD.decodeValue usersListDecoder raw of
                Ok usersInChannel ->
                    ( { model | usersInChannel = usersInChannel.users }, Cmd.none )

                Err error ->
                    ( model, Cmd.none )

        JoinChannel ->
            let
                channel =
                    Phoenix.Channel.init "rooms:lobby"

                ( socket, cmd ) =
                    Phoenix.Socket.join channel model.socket
            in
                ( { model | socket = socket }
                , Cmd.map PhoenixMsg cmd
                )

        SendMessage ->
            let
                payload =
                    (JE.object [ ( "body", JE.string "New MESSAGE!" ) ])

                push_ =
                    Phoenix.Push.init "new:msg" "rooms:lobby"
                        |> Phoenix.Push.withPayload payload

                ( socket, cmd ) =
                    Phoenix.Socket.push push_ model.socket
            in
                ( { model | socket = socket }, Cmd.map PhoenixMsg cmd )
