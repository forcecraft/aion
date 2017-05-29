module Models.Models exposing (..)

import RemoteData exposing (WebData)
import Msgs exposing (Msg)
import Phoenix.Socket
import Models.Room exposing (RoomsData, RoomId)


type alias Model =
    { user : UserModel
    , rooms : WebData RoomsData
    , route : Route
    , socket : Phoenix.Socket.Socket Msg
    , usersInChannel : UsersInChannel
    }


type alias UserModel =
    { channelToken : String
    , username : String
    }


initialModel : Flags -> Route -> Model
initialModel flags route =
    { user =
        { username = ""
        , channelToken = flags.channelToken
        }
    , rooms = RemoteData.Loading
    , route = route
    , socket =
        Phoenix.Socket.init ("ws://localhost:4000/socket/websocket?token=" ++ flags.channelToken)
            |> Phoenix.Socket.withDebug
    , usersInChannel = []
    }


type alias Flags =
    { channelToken : String
    }


type Route
    = LoginRoute
    | RoomsRoute
    | RoomRoute RoomId
    | NotFoundRoute


type alias UsersInChannel =
    List String
