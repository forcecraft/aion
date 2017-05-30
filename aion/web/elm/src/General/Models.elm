module General.Models exposing (..)

import Msgs exposing (Msg)
import Phoenix.Socket
import RemoteData exposing (WebData)
import Room.Models exposing (RoomId, RoomsData, UserGameData, UsersInRoom)


-- MODEL


type alias Model =
    { user : CurrentUser
    , rooms : WebData RoomsData
    , route : Route
    , socket : Phoenix.Socket.Socket Msg
    , usersInChannel : UsersInRoom
    , userGameData : UserGameData
    }


type alias CurrentUser =
    { channelToken : String
    , name : String
    }


type alias Flags =
    { channelToken : String
    }



-- ROUTE


type Route
    = LoginRoute
    | RoomListRoute
    | RoomRoute RoomId
    | NotFoundRoute



-- INITIAL MODEL


initialModel : Flags -> Route -> Model
initialModel flags route =
    { user =
        { name = ""
        , channelToken = flags.channelToken
        }
    , rooms = RemoteData.Loading
    , route = route
    , socket =
        Phoenix.Socket.init ("ws://localhost:4000/socket/websocket?token=" ++ flags.channelToken)
            |> Phoenix.Socket.withDebug
    , usersInChannel = []
    , userGameData = { currentAnswer = "" }
    }
