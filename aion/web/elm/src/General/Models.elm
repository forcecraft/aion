module General.Models exposing (..)

import Bootstrap.Navbar as Navbar
import Forms
import Msgs exposing (Msg(NavbarMsg))
import Panel.Models exposing (CategoriesData, PanelData, categoryForm, questionForm)
import Phoenix.Socket
import RemoteData exposing (WebData)
import Room.Models exposing (RoomId, RoomsData, UsersInRoom, QuestionInRoom, UserGameData)
import Toasty
import Toasty.Defaults
import User.Models exposing (CurrentUser)


type alias Model =
    { user : WebData CurrentUser
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
    = LoginRoute
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
        , channelToken = flags.channelToken
        , rooms = RemoteData.Loading
        , categories = RemoteData.Loading
        , route = route
        , socket =
            Phoenix.Socket.init ("ws://localhost:4000/socket/websocket?token=" ++ flags.channelToken)
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
            }
        , navbarState = navbarState
        }
