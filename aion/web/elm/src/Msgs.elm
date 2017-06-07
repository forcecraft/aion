module Msgs exposing (..)

import Dom exposing (Error)
import Navigation exposing (Location)
import RemoteData exposing (WebData)
import Phoenix.Socket
import Json.Encode as Encode
import Room.Models exposing (RoomId, RoomsData)
import User.Models exposing (CurrentUser)


type Msg
    = OnLocationChange Location
    | OnFetchRooms (WebData RoomsData)
    | OnFetchCurrentUser (WebData CurrentUser)
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | ReceiveUserList Encode.Value
    | SetAnswer String
    | SubmitAnswer RoomId
    | ReceiveQuestion Encode.Value
    | FocusResult (Result Error ())
    | KeyDown Int
