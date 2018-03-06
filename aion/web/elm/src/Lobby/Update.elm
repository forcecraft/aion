module Lobby.Update exposing (..)

import General.Models exposing (Model)
import Lobby.Msgs exposing (LobbyMsg(OnFetchRooms))


update : LobbyMsg -> Model -> ( Model, Cmd LobbyMsg )
update msg model =
    case msg of
        OnFetchRooms response ->
            { model | rooms = response } ! []
