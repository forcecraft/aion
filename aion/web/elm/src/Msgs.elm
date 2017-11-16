module Msgs exposing (..)

import Auth.Models exposing (RegistrationResultData)
import Bootstrap.Navbar as Navbar
import Dom exposing (Error)
import Http
import Navigation exposing (Location)
import Multiselect
import Panel.Models exposing (CategoriesData, CategoryCreatedData, QuestionCreatedData, RoomCreatedData)
import Ranking.Models exposing (Ranking)
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
    | OnFetchRanking (WebData Ranking)
    | OnFetchCategories (WebData CategoriesData)
    | OnFetchCurrentUser (WebData CurrentUser)
    | OnQuestionCreated (WebData QuestionCreatedData)
    | OnCategoryCreated (WebData CategoryCreatedData)
    | OnRoomCreated (WebData RoomCreatedData)
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | ReceiveUserList Encode.Value
    | SetAnswer String
    | SubmitAnswer
    | ReceiveQuestion Encode.Value
    | FocusResult (Result Error ())
    | KeyDown Int
    | NoOperation
    | ReceiveAnswerFeedback Encode.Value
    | ReceiveUserJoined Encode.Value
    | ReceiveDisplayQuestion Encode.Value
    | ReceiveQuestionBreak Encode.Value
    | ToastyMsg (Toasty.Msg Toasty.Defaults.Toast)
    | CreateNewQuestionWithAnswers
    | CreateNewCategory
    | CreateNewRoom
    | Login
    | LoginResult (Result Http.Error String)
    | Register
    | RegistrationResult (WebData RegistrationResultData)
    | Logout
    | ChangeAuthForm
    | UpdateLoginForm String String
    | UpdateRegistrationForm String String
    | UpdateQuestionForm String String
    | UpdateCategoryForm String String
    | UpdateRoomForm String String
    | MultiselectMsg Multiselect.Msg
    | NavbarMsg Navbar.State
    | LeaveRoom RoomId
    | OnRankingCategoryChange String
