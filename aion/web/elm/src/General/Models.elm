module General.Models exposing (..)

import Auth.Models exposing (AuthData, loginForm)
import Bootstrap.Navbar as Navbar
import Forms
import Msgs exposing (Msg(NavbarMsg))
import Multiselect
import Panel.Models exposing (CategoriesData, PanelData, categoryForm, questionForm, roomForm)
import Phoenix.Socket
import RemoteData exposing (WebData)
import Room.Models exposing (RoomId, RoomsData, UsersInRoom, QuestionInRoom, UserGameData)
import Toasty
import Toasty.Defaults
import User.Models exposing (CurrentUser)


type alias Model =
    { user : WebData CurrentUser
    , authData : AuthData
    , channelToken : String
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
    }


type alias Flags =
    { channelToken : String
    }


type Route
    = HomeRoute
    | AuthRoute
    | RoomListRoute
    | RoomRoute RoomId
    | PanelRoute
    | UserRoute
    | NotFoundRoute


type alias SimpleCardConfig =
    { svgImage : String
    , title : String
    , description : String
    , url : String
    , buttonText : String
    }


initialModel : Flags -> Route -> Model
initialModel flags route =
    let
        ( navbarState, _ ) =
            Navbar.initialState NavbarMsg
    in
        { user = RemoteData.Loading
        , authData =
            { loginForm = Forms.initForm loginForm
            , token = Nothing
            , msg = ""
            }
        , channelToken = flags.channelToken
        , rooms = RemoteData.Loading
        , categories = RemoteData.Loading
        , route = route
        , socket = Phoenix.Socket.init ""
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
        }
