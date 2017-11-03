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


type alias UserRecord =
    { name : String
    , score : Int
    , questionsAsked : Int
    }



-- ^ to underscore


type alias UserList =
    List UserRecord


type alias UserListMessage =
    { users : UserList }


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
