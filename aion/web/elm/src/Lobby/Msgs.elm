module Lobby.Msgs exposing (..)

import Lobby.Models exposing (LobbyData)
import RemoteData exposing (WebData)


type LobbyMsg
    = OnFetchRooms (WebData LobbyData)
