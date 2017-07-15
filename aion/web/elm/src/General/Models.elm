module General.Models exposing (..)

import Msgs exposing (Msg)
import Panel.Models exposing (PanelData)
import Phoenix.Socket
import RemoteData exposing (WebData)
import Room.Models exposing (RoomId, RoomsData, UsersInRoom, QuestionInRoom, UserGameData)
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
    , panelData =
        { newQuestionContent = ""
        , newAnswerContent = ""
        }
    }
