module General.Models exposing (..)

import Auth.Models exposing (AuthData, Token, UnauthenticatedViewToggle(LoginView), initAuthData, loginForm, registrationForm)
import Bootstrap.Navbar as Navbar
import Lobby.Models exposing (LobbyData, initLobbyData)
import Msgs exposing (Msg(NavbarMsg))
import Navigation exposing (Location)
import Panel.Models exposing (CategoriesData, PanelData, categoryForm, initPanelData, questionForm, roomForm)
import Phoenix.Socket
import Room.Models exposing (CurrentQuestion, EventLog, ProgressBar, RoomData, RoomState(QuestionBreak), UserGameData, UserList, initRoomData)
import Ranking.Models exposing (RankingData, initRankingData)
import Room.Msgs exposing (RoomMsg)
import Room.Socket exposing (initSocket)
import Toasty
import Toasty.Defaults
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
    | LobbyRoute
    | RoomRoute Int
    | CreateRoomRoute
    | RankingRoute
    | UserRoute
    | NotFoundRoute


initModel : Flags -> Route -> Location -> Model
initModel flags route location =
    let
        ( navbarState, _ ) =
            Navbar.initialState NavbarMsg

        maybeToken =
            initToken flags

        token =
            case maybeToken of
                Just actualToken ->
                    actualToken

                Nothing ->
                    ""
    in
        { authData = initAuthData maybeToken
        , lobbyData = initLobbyData
        , panelData = initPanelData
        , rankingData = initRankingData
        , roomData = initRoomData location
        , userData = initUserData location
        , route = route
        , socket = initSocket token location
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
