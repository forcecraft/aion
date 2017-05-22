module Commands exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Msgs exposing (Msg)
import Models.Room exposing (RoomId, Room, RoomsData)
import RemoteData


fetchRooms : Cmd Msg
fetchRooms =
    Http.get fetchRoomsUrl roomsDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchRooms


fetchRoomsUrl : String
fetchRoomsUrl =
    "http://localhost:4000/api/subjects"


roomsDecoder : Decode.Decoder (RoomsData)
roomsDecoder =
  decode RoomsData
        |> required "data" (Decode.list(roomDecoder))


roomDecoder : Decode.Decoder Room
roomDecoder =
    decode Room
        |> required "id" Decode.int
        |> required "name" Decode.string
