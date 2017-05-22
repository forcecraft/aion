module Models.Room exposing (..)

type alias RoomId =
    Int

type alias Room =
  {
    id : RoomId
  , name : String
  }

type alias RoomsData = { data : List Room }
