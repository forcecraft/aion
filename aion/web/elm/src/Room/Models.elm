module Room.Models exposing (..)

import Navigation exposing (Location)
import Toasty
import Toasty.Defaults


type alias RoomData =
    { currentQuestion : CurrentQuestion
    , eventLog : EventLog
    , location : Location
    , progressBar : ProgressBar
    , roomId : Int
    , roomState : RoomState
    , toasties : Toasty.Stack Toasty.Defaults.Toast
    , userList : UserList
    , userGameData : UserGameData
    }


initRoomData : Location -> RoomData
initRoomData location =
    { currentQuestion = initCurrentQuestion
    , eventLog = initEventLog
    , location = location
    , roomId = 0
    , roomState = QuestionBreak
    , progressBar = initProgressBar
    , toasties = Toasty.initialState
    , userList = []
    , userGameData = initUserGameData
    }


type RoomState
    = QuestionDisplayed
    | QuestionBreak


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


initUserGameData : UserGameData
initUserGameData =
    { currentAnswer = "" }


type alias CurrentQuestion =
    { content : String
    , image_name : ImageName
    }


initCurrentQuestion : CurrentQuestion
initCurrentQuestion =
    { content = ""
    , image_name = ""
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
    String


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


initEventLog : EventLog
initEventLog =
    []


type alias ProgressBar =
    { start : Float
    , progress : Float
    , running : ProgressBarState
    }


initProgressBar : ProgressBar
initProgressBar =
    { start = 0.0
    , progress = 0.0
    , running = Uninitialized
    }


type ProgressBarState
    = Running
    | Uninitialized
    | Stopped


type alias Progress =
    Float


withProgress : Progress -> ProgressBar -> ProgressBar
withProgress progress bar =
    { bar | progress = progress }


withRunning : ProgressBarState -> ProgressBar -> ProgressBar
withRunning running bar =
    { bar | running = running }


withStart : Float -> ProgressBar -> ProgressBar
withStart start bar =
    { bar | start = start }


asEventLogIn : RoomData -> EventLog -> RoomData
asEventLogIn model eventLog =
    { model | eventLog = eventLog }


asProgressBarIn : RoomData -> ProgressBar -> RoomData
asProgressBarIn model bar =
    { model | progressBar = bar }
