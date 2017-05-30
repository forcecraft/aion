module Update exposing (..)

import General.Models exposing (Model, Route(RoomRoute))
import Json.Decode as Decode
import Msgs exposing (Msg(..))
import Room.Decoders exposing (questionDecoder, usersListDecoder)
import Routing exposing (parseLocation)
import Phoenix.Socket
import Phoenix.Channel


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
                                Phoenix.Socket.join channel
                                    (model.socket
                                        |> Phoenix.Socket.on "user:list" ("rooms:" ++ roomIdToString) ReceiveUserList
                                        |> Phoenix.Socket.on "new:question" ("rooms:" ++ roomIdToString) ReceiveQuestion
                                    )
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
            case Decode.decodeValue usersListDecoder raw of
                Ok usersInChannel ->
                    ( { model | usersInChannel = usersInChannel.users }, Cmd.none )

                Err error ->
                    ( model, Cmd.none )

        SetAnswer newAnswer ->
            let
                debug =
                    Debug.log "newanswer" newAnswer
            in
                ( model, Cmd.none )

        ReceiveQuestion raw ->
            case Decode.decodeValue questionDecoder raw of
                Ok question ->
                    ( { model | questionInChannel = question }, Cmd.none )

                Err error ->
                    ( model, Cmd.none )
