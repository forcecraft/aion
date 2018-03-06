module Lobby.Models exposing (..)

import RemoteData


type alias LobbyData =
    { data : List Room }


initLobbyData : LobbyData
initLobbyData =
    RemoteData.Loading


type alias Room =
    { id : RoomId
    , name : String
    , description : String
    , player_count : Int
    }


type alias RoomId =
    Int
