module Room.Models exposing (..)


type alias RoomId =
    Int


type alias Room =
    { id : RoomId
    , name : String
    , description : String
    , player_count : Int
    }


type alias RoomsData =
    { data : List Room }


type alias UsersInRoom =
    List UserInRoomRecord


type alias UserInRoomRecord =
    { name : String
    , score : Int
    }


type alias UserList =
    { users : List UserInRoomRecord }


type alias UserGameData =
    { currentAnswer : String }


type alias QuestionInRoom =
    { content : String
    , image_name : ImageName
    }


type alias UserJoinedInfo =
    { user : String
    }


type alias AnswerFeedback =
    { feedback : String }


type alias ImageName =
    String


type alias Answer =
    String
