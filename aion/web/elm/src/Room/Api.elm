module Room.Api exposing (..)

import Http exposing (Request)
import Json.Decode as Decode
import Msgs exposing (Msg)
import Navigation exposing (Location)
import RemoteData
import Room.Decoders exposing (roomsDecoder)
import Room.Models exposing (RoomsData)
import Urls exposing (host, roomsUrl)


fetchCurrentUserRequest : String -> String -> Decode.Decoder RoomsData -> Request RoomsData
fetchCurrentUserRequest url token decoder =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ token) ]
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = True
        }


fetchRooms : Location -> String -> Cmd Msg
fetchRooms location token =
    let
        url =
            roomsUrl location
    in
        fetchCurrentUserRequest url token roomsDecoder
            |> RemoteData.sendRequest
            |> Cmd.map Msgs.OnFetchRooms
