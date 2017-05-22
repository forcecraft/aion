module Update exposing (..)

import Models.Models exposing (Model)
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


update: Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    OnFetchRooms response ->
      ( { model | rooms = response }, Cmd.none )

    OnLocationChange location ->
      let
        newRoute =
          parseLocation location
      in
        ( { model | route = newRoute }, Cmd.none )

    PhoenixMsg msg ->
      let
        ( socket, cmd ) = Phoenix.Socket.update msg model.socket
      in
        ( { model | socket = socket }
        , Cmd.map PhoenixMsg cmd
        )

    ReceiveChatMessage raw ->
      case JD.decodeValue chatMessageDecoder raw of
          Ok chatMessage ->
            let
              info = Debug.log chatMessage.body 1
            in
              ( model , Cmd.none )
          Err error ->
              ( model, Cmd.none )

    JoinChannel ->
        let
            channel = Phoenix.Channel.init "rooms:lobby"

            ( socket, cmd ) = Phoenix.Socket.join channel model.socket
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
