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
        , socket =
            Phoenix.Socket.init ("ws://localhost:4000/socket/websocket?token=" ++ "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJVc2VyOjYiLCJleHAiOjE1MDk4NzkzNTQsImlhdCI6MTUwNzI4NzM1NCwiaXNzIjoiQWlvbiIsImp0aSI6IjJjZTRkMTdkLTMwNDMtNGQyNi05MWU0LWYyNjlmNDNiZjU3OSIsInBlbSI6e30sInN1YiI6IlVzZXI6NiIsInR5cCI6ImFjY2VzcyJ9.yp9MLzhbfKFiVD3FzV6vJER8jWQnJIuVyirbGuk181PexFMpuoH4arvWL8n1-q72BYSu2Egzp3HMLwGjVjVZ_g")
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
        }
