module General.Models exposing (..)

import Auth.Models exposing (AuthData, UnauthenticatedViewToggle(LoginView), loginForm, registrationForm)
import Bootstrap.Navbar as Navbar
import Forms
import General.Constants exposing (loginFormMsg)
import Msgs exposing (Msg(NavbarMsg))
import Navigation exposing (Location)
import Multiselect
import Panel.Models exposing (CategoriesData, PanelData, categoryForm, questionForm, roomForm)
import Phoenix.Socket
import RemoteData exposing (WebData)
import Room.Models exposing (RoomId, RoomsData, UsersInRoom, QuestionInRoom, UserGameData)
import Toasty
import Toasty.Defaults
import Urls exposing (hostname, websocketUrl)
import User.Models exposing (CurrentUser)


type alias Model =
    { user : WebData CurrentUser
    , authData : AuthData
    , rooms : WebData RoomsData
    , categories : WebData CategoriesData
    , route : Route
    , socket : Phoenix.Socket.Socket Msg
    , usersInChannel : UsersInRoom
    , userGameData : UserGameData
    , questionInChannel : QuestionInRoom
    , roomId : RoomId
    , toasties : Toasty.Stack Toasty.Defaults.Toast
    , panelData : PanelData
    , navbarState : Navbar.State
    , location : Location
    }


type alias Flags =
    { token : String
    }


type Route
    = HomeRoute
    | AuthRoute
    | RoomListRoute
    | RoomRoute RoomId
    | PanelRoute
    | UserRoute
    | NotFoundRoute


initialModel : Flags -> Route -> Location -> Model
initialModel flags route location =
    let
        ( navbarState, _ ) =
            Navbar.initialState NavbarMsg

        token =
            case String.isEmpty flags.token of
                True ->
                    Nothing

                False ->
                    Just flags.token
    in
        { user = RemoteData.Loading
        , authData =
            { loginForm = Forms.initForm loginForm
            , registrationForm = Forms.initForm registrationForm
            , unauthenticatedView = LoginView
            , formMsg = loginFormMsg
            , token = token
            , msg = ""
            }
        , rooms = RemoteData.Loading
        , categories = RemoteData.Loading
        , route = route
        , socket =
            Phoenix.Socket.init (websocketUrl location flags.token)
                |> Phoenix.Socket.withDebug
        , usersInChannel = []
        , userGameData = { currentAnswer = "" }
        , questionInChannel =
            { content = ""
            , image_name = ""
            }
        , roomId = 0
        , toasties = Toasty.initialState
        , panelData =
            { questionForm = Forms.initForm questionForm
            , categoryForm = Forms.initForm categoryForm
            , roomForm = Forms.initForm roomForm
            , categoryMultiSelect = Multiselect.initModel [] "id"
            }
        , navbarState = navbarState
        , location = location
        }
