module General.Models exposing (..)

import Auth.Models exposing (AuthData, Token, UnauthenticatedViewToggle(LoginView), initAuthData, loginForm, registrationForm)
import Bootstrap.Navbar as Navbar
import Forms
import Lobby.Models exposing (LobbyData, initLobbyData)
import Msgs exposing (Msg(NavbarMsg))
import Navigation exposing (Location)
import Multiselect
import Panel.Models exposing (CategoriesData, PanelData, categoryForm, initPanelData, questionForm, roomForm)
import Phoenix.Socket
import RemoteData exposing (WebData)
import Room.Models exposing (CurrentQuestion, EventLog, ProgressBar, RoomData, RoomState(QuestionBreak), UserGameData, UserList, initRoomData, initialLog, initialProgressBar)
import Ranking.Models exposing (RankingData, initRankingData)
import Room.Msgs exposing (RoomMsg)
import Room.Socket exposing (initSocket)
import Toasty
import Toasty.Defaults
import Urls exposing (hostname, websocketUrl)
import User.Models exposing (UserData, initUserData)


type alias Model =
    { authData : AuthData
    , lobbyData : LobbyData
    , panelData : PanelData
    , rankingData : RankingData
    , roomData : RoomData
    , userData : UserData
    , route : Route
    , socket : Phoenix.Socket.Socket RoomMsg
    , toasties : Toasty.Stack Toasty.Defaults.Toast
    , navbarState : Navbar.State
    , location : Location
    }


type alias Flags =
    { token : Token
    }


type Route
    = AuthRoute
    | RoomListRoute
    | RoomRoute Int
    | CreateRoomRoute
    | RankingRoute
    | UserRoute
    | NotFoundRoute


initialModel : Flags -> Route -> Location -> Model
initialModel flags route location =
    let
        ( navbarState, _ ) =
            Navbar.initialState NavbarMsg

        token =
            initToken flags
    in
        { authData = initAuthData token
        , lobbyData = initLobbyData
        , panelData = initPanelData
        , rankingData = initRankingData
        , userData = initUserData
        , roomData = initRoomData
        , route = route
        , socket = initSocket
        , toasties = Toasty.initialState
        , navbarState = navbarState
        , location = location
        }


initToken : Flags -> Maybe Token
initToken flags =
    case String.isEmpty flags.token of
        True ->
            Nothing

        False ->
            Just flags.token
