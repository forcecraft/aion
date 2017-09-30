module Room.Api exposing (..)

import Http
import Msgs exposing (Msg)
import Navigation exposing (Location)
import RemoteData
import Room.Decoders exposing (roomsDecoder)
import Urls exposing (host, roomsUrl)


fetchRooms : Location -> Cmd Msg
fetchRooms location =
    Http.get (roomsUrl location) roomsDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchRooms
