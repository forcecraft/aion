module Room.Models exposing (..)


type alias RoomId =
    Int


type alias Room =
    { id : RoomId
    , name : String
    }


type alias RoomsData =
    { data : List Room }


type alias UsersInRoom =
    List UserInRoomRecord


type alias UserInRoomRecord =
    { name : String
    , score : Int
    }
