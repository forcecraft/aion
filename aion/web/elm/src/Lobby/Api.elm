module Lobby.Api exposing (..)

import General.Msgs exposing (GeneralMsg(OnFetchRooms))
import Http exposing (Error(BadStatus))
import RemoteData


unauthorized : GeneralMsg -> Bool
unauthorized msg =
    case msg of
        OnFetchRooms (RemoteData.Failure (BadStatus response)) ->
            response.status.code == 401

        _ ->
            False
