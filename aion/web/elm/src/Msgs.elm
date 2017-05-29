module Msgs exposing (..)

import Navigation exposing (Location)
import RemoteData exposing (WebData)
import Models.Room exposing (RoomsData)
import Phoenix.Socket
import Json.Encode as JE


type Msg
    = OnLocationChange Location
    | OnFetchRooms (WebData RoomsData)
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | ReceiveUserList JE.Value
    | JoinChannel
    | SendMessage
