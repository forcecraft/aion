module Lobby.Update exposing (..)

import Lobby.Models exposing (LobbyData, initLobbyData)
import Lobby.Msgs exposing (LobbyMsg(OnFetchRooms))
import RemoteData


update : LobbyMsg -> LobbyData -> ( LobbyData, Cmd LobbyMsg )
update msg model =
    case msg of
        OnFetchRooms response ->
            let
                lobbyData =
                    case response of
                        RemoteData.Success rooms ->
                            rooms

                        _ ->
                            initLobbyData
            in
                lobbyData ! []
