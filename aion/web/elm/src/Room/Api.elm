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


fetchRooms : Cmd Msg
fetchRooms =
    Http.get fetchRoomsUrl roomsDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchRooms
