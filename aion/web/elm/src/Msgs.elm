module Msgs exposing (..)

import Auth.Models exposing (RegistrationResultData)
import Auth.Msgs exposing (AuthMsg)
import Bootstrap.Navbar as Navbar
import Dom exposing (Error)
import General.Msgs exposing (GeneralMsg)
import Http
import Navigation exposing (Location)
import Multiselect
import Panel.Models exposing (CategoriesData, CategoryCreatedData, QuestionCreatedData, RoomCreatedData)
import Panel.Msgs exposing (PanelMsg)
import Ranking.Models exposing (Ranking)
import Ranking.Msgs exposing (RankingMsg)
import RemoteData exposing (WebData)
import Phoenix.Socket
import Json.Encode as Encode
import Room.Models exposing (RoomId, RoomsData)
import Room.Msgs exposing (RoomMsg)
import Time exposing (Time)
import Toasty
import Toasty.Defaults
import User.Models exposing (CurrentUser, UserScores)
import User.Msgs exposing (UserMsg)


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
