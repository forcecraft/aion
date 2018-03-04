module Room.Msgs exposing (..)

import Dom exposing (Error)
import Time exposing (Time)
import Json.Encode as Encode
import Phoenix.Socket
import Toasty
import Toasty.Defaults


type RoomMsg
    = Tick Time
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
    | PhoenixMsg (Phoenix.Socket.Msg RoomMsg)
    | ToastyMsg (Toasty.Msg Toasty.Defaults.Toast)
