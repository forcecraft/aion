module Models.Room exposing (..)

type alias RoomId =
    String

type alias Room =
  {
    id : RoomId
  , name : String
  }

type alias RoomsData = { data : List Room }
