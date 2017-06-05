module Room.Api exposing (..)

import Http
import Msgs exposing (Msg)
import RemoteData
import Room.Decoders exposing (roomsDecoder)


fetchRoomsUrl : String
fetchRoomsUrl =
    "http://localhost:4000/api/subjects"


fetchRooms : Cmd Msg
fetchRooms =
    Http.get fetchRoomsUrl roomsDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchRooms
