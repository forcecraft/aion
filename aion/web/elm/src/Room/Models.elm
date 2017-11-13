module Room.Models exposing (..)


type alias RoomId =
    Int


type alias Room =
    { id : RoomId
    , name : String
    , description : String
    , player_count : Int
    }


type RoomState
    = QuestionDisplayed
    | QuestionBreak


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


type alias CurrentQuestion =
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


type alias EventLog =
    List Event


type Event
    = MkUserJoinedLog UserJoined
    | MkUserLeftLog UserLeft
    | MkQuestionSummaryLog QuestionSummary


type alias UserJoined =
    { currentPlayer : String
    , newPlayer : String
    }


type alias UserLeft =
    { user : String
    }


type alias QuestionSummary =
    { winner : String
    , answers : List String
    }


asLogIn : EventLog -> Event -> EventLog
asLogIn eventLog event =
    event :: eventLog


initialLog : EventLog
initialLog =
    []
