module Room.Api exposing (..)

import General.Constants exposing (roomsUrl, hostname)
import Http
import Msgs exposing (Msg)
import RemoteData
import Room.Decoders exposing (roomsDecoder)


fetchRooms : Cmd Msg
fetchRooms =
    Http.get roomsUrl roomsDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchRooms
