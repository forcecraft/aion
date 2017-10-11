module Room.Api exposing (..)

import General.Constants exposing (roomsUrl, hostname)
import Http exposing (Request)
import Json.Decode as Decode
import Msgs exposing (Msg)
import RemoteData
import Room.Decoders exposing (roomsDecoder)
import Room.Models exposing (RoomsData)


fetchCurrentUserRequest : String -> Decode.Decoder RoomsData -> Request RoomsData
fetchCurrentUserRequest token decoder =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ token) ]
        , url = roomsUrl
        , body = Http.emptyBody
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = True
        }


fetchRooms : String -> Cmd Msg
fetchRooms token =
    fetchCurrentUserRequest token roomsDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchRooms
