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
import Time exposing (Time)
import Toasty
import Toasty.Defaults
import User.Models exposing (CurrentUser, UserScores)


type Msg
    = OnLocationChange Location
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | ToastyMsg (Toasty.Msg Toasty.Defaults.Toast)
    | MultiselectMsg Multiselect.Msg
    | NavbarMsg Navbar.State
      -- sub page types
    | MkRoomMsg RoomMsg
    | MkRankingMsg RankingMsg
    | MkUserMsg UserMsg
    | MkPanelMsg PanelMsg
    | MkAuthMsg AuthMsg
    | MkGeneralMsg GeneralMsg


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


type RankingMsg
    = OnRankingCategoryChange String
    | OnFetchRanking (WebData Ranking)
    | OnFetchCategories (WebData CategoriesData)


type UserMsg
    = OnFetchCurrentUser (WebData CurrentUser)
    | OnFetchUserScores (WebData UserScores)


type PanelMsg
    = UpdateQuestionForm String String
    | UpdateCategoryForm String String
    | UpdateRoomForm String String
    | OnQuestionCreated (WebData QuestionCreatedData)
    | OnCategoryCreated (WebData CategoryCreatedData)
    | OnRoomCreated (WebData RoomCreatedData)
    | CreateNewQuestionWithAnswers
    | CreateNewCategory
    | CreateNewRoom


type AuthMsg
    = Login
    | LoginResult (Result Http.Error String)
    | Register
    | RegistrationResult (WebData RegistrationResultData)
    | Logout
    | ChangeAuthForm
    | UpdateLoginForm String String
    | UpdateRegistrationForm String String


type GeneralMsg
    = OnFetchRooms (WebData RoomsData)
