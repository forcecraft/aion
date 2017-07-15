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


type alias UserList =
    { users : List UserInRoomRecord }


type alias UserGameData =
    { currentAnswer : String
    }


type alias QuestionInRoom =
    { content : String
    , image_name : ImageName
    }


type alias ImageName =
    String


answerInputFieldId : Answer
answerInputFieldId =
    "answerInputField"


type alias Answer =
    String
