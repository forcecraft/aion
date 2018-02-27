module Room.Msgs exposing (..)

import Dom exposing (Error)
import Time exposing (Time)
import Json.Encode as Encode


type RoomMsg
    = LeaveRoom
    | Tick Time
    | OnTime Time
    | OnInitialTime Time
    | FocusResult (Result Error ())
    | KeyDown Int
    | NoOperation
    | SetAnswer String
    | SubmitAnswer
    | ReceiveQuestion Encode.Value
    | ReceiveAnswerFeedback Encode.Value
    | ReceiveDisplayQuestion Encode.Value
    | ReceiveQuestionBreak Encode.Value
    | ReceiveUserJoined Encode.Value
    | ReceiveUserLeft Encode.Value
    | ReceiveUserList Encode.Value
    | ReceiveQuestionSummary Encode.Value
