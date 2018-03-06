module Lobby.Api exposing (..)

import Auth.Models exposing (Token)
import Http exposing (Error(BadStatus))
import Lobby.Msgs exposing (LobbyMsg(OnFetchRooms))
import Navigation exposing (Location)
import RemoteData
import Room.Decoders exposing (roomsDecoder)
import Urls exposing (roomsUrl)
import User.Api exposing (fetchCurrentUserRequest)


unauthorized : LobbyMsg -> Bool
unauthorized msg =
    case msg of
        OnFetchRooms (RemoteData.Failure (BadStatus response)) ->
            response.status.code == 401

        _ ->
            False


fetchRooms : Location -> Token -> Cmd LobbyMsg
fetchRooms location token =
    let
        url =
            roomsUrl location
    in
        fetchCurrentUserRequest url token roomsDecoder
            |> RemoteData.sendRequest
            |> Cmd.map OnFetchRooms
