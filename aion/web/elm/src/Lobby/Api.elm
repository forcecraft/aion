module Lobby.Api exposing (..)

import Auth.Models exposing (Token)
import Http exposing (Error(BadStatus), Request)
import Lobby.Decoders exposing (roomListDecoder)
import Lobby.Msgs exposing (LobbyMsg(OnFetchRooms))
import Navigation exposing (Location)
import RemoteData
import Urls exposing (roomsUrl)
import User.Api exposing (fetchCurrentUserRequest)
import Json.Decode as Decode
import Lobby.Models exposing (LobbyData)


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
        fetchRoomsRequest url token roomListDecoder
            |> RemoteData.sendRequest
            |> Cmd.map OnFetchRooms


fetchRoomsRequest : String -> String -> Decode.Decoder LobbyData -> Request LobbyData
fetchRoomsRequest url token decoder =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ token) ]
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = True
        }
