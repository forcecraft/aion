module Msgs exposing (..)

import Dom exposing (Error)
import Navigation exposing (Location)
import Panel.Models exposing (QuestionCreatedData)
import RemoteData exposing (WebData)
import Phoenix.Socket
import Json.Encode as Encode
import Room.Models exposing (RoomId, RoomsData)
import Toasty
import Toasty.Defaults
import User.Models exposing (CurrentUser)


type Msg
    = OnLocationChange Location
    | OnFetchRooms (WebData RoomsData)
    | OnFetchCurrentUser (WebData CurrentUser)
    | OnQuestionCreated (WebData QuestionCreatedData)
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | ReceiveUserList Encode.Value
    | SetAnswer String
    | SubmitAnswer
    | ReceiveQuestion Encode.Value
    | FocusResult (Result Error ())
    | KeyDown Int
    | NoOperation
    | ReceiveAnswerFeedback Encode.Value
    | ToastyMsg (Toasty.Msg Toasty.Defaults.Toast)
    | SetNewQuestionContent String
    | SetNewAnswerContent String
    | SetNewAnswerCategory String
    | CreateNewQuestionWithAnswers
