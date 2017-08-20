module General.Models exposing (..)

import Forms
import Msgs exposing (Msg)
import Panel.Models exposing (PanelData, categoryForm, questionForm)
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
    , route : Route
    , socket : Phoenix.Socket.Socket Msg
    , usersInChannel : UsersInRoom
    , userGameData : UserGameData
    , questionInChannel : QuestionInRoom
    , roomId : RoomId
    , toasties : Toasty.Stack Toasty.Defaults.Toast
    , panelData : PanelData
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


initialModel : Flags -> Route -> Model
initialModel flags route =
    { user = RemoteData.Loading
    , channelToken = flags.channelToken
    , rooms = RemoteData.Loading
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
    }
