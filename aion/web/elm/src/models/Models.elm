module Models.Models exposing (..)

import RemoteData exposing (WebData)
import Msgs exposing (Msg)
import Phoenix.Socket
import Models.Room exposing (RoomsData, RoomId)

type alias Model =
  { username: String
  , rooms: WebData (RoomsData)
  , route: Route
  , socket: Phoenix.Socket.Socket Msg
  }

initialModel: Route -> Model
initialModel route =
  { username = ""
  , rooms = RemoteData.Loading
  , route = route
  , socket =
    Phoenix.Socket.init "ws://localhost:4000/socket/websocket"
        |> Phoenix.Socket.on "new:msg" "rooms:lobby" Msgs.ReceiveChatMessage
  }

-- ROUTING
type Route
  = LoginRoute
  | RoomsRoute
  | RoomRoute RoomId
  | NotFoundRoute
