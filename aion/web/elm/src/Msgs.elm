module Msgs exposing(..)

import Navigation exposing (Location)
import RemoteData exposing (WebData)
import Models.Room exposing(RoomsData)
import Phoenix.Socket
import Json.Encode as JE

type Msg
  = UpdateUsername String
  | OnLocationChange Location
  | OnFetchRooms (WebData (RoomsData))
  | PhoenixMsg (Phoenix.Socket.Msg Msg)
  | ReceiveChatMessage JE.Value
  | JoinChannel
  | SendMessage
