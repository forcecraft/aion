module Msgs exposing (..)

import Navigation exposing (Location)
import RemoteData exposing (WebData)
import Phoenix.Socket
import Json.Encode as Encode
import Room.Models exposing (RoomsData)


type Msg
    = OnLocationChange Location
    | OnFetchRooms (WebData RoomsData)
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | ReceiveUserList Encode.Value
