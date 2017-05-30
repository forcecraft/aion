module Room.Decoders exposing (..)

import Json.Decode.Pipeline exposing (decode, required)
import Room.Models exposing (Room, RoomsData)
import Json.Decode as Decode


roomsDecoder : Decode.Decoder RoomsData
roomsDecoder =
    decode RoomsData
        |> required "data" (Decode.list (roomDecoder))


roomDecoder : Decode.Decoder Room
roomDecoder =
    decode Room
        |> required "id" Decode.int
        |> required "name" Decode.string
