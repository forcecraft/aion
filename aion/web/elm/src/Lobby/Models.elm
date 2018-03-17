module Lobby.Models exposing (..)

import RemoteData


type alias LobbyData =
    { data : List Room }



-- experimental


type alias RoomList =
    List Room



-- /experimental


type alias Room =
    { id : RoomId
    , name : String
    , description : String
    , player_count : Int
    }


type alias RoomId =
    Int


initLobbyData : LobbyData
initLobbyData =
    { data = [] }
