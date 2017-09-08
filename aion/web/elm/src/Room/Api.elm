module Room.Api exposing (..)

import General.Constants exposing (hostname)
import Http
import Msgs exposing (Msg)
import RemoteData
import Room.Decoders exposing (roomsDecoder)


fetchRoomsUrl : String
fetchRoomsUrl =
    hostname ++ "api/categories"


fetchRooms : Cmd Msg
fetchRooms =
    Http.get fetchRoomsUrl roomsDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchRooms
