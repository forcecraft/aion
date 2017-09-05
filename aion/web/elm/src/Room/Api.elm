module Room.Api exposing (..)

import General.Constants exposing (host)
import Http
import Msgs exposing (Msg)
import Navigation exposing (Location)
import RemoteData
import Room.Decoders exposing (roomsDecoder)


fetchRoomsUrl : Location -> String
fetchRoomsUrl location =
    (host location) ++ "api/subjects"


fetchRooms : Location -> Cmd Msg
fetchRooms location =
    Http.get (fetchRoomsUrl location) roomsDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchRooms
