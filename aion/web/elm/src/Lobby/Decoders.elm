module Lobby.Decoders exposing (..)

import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Lobby.Models exposing (LobbyData, Room)


roomListDecoder : Decode.Decoder LobbyData
roomListDecoder =
    decode LobbyData
        |> required "data" (Decode.list (roomDecoder))


roomDecoder : Decode.Decoder Room
roomDecoder =
    decode Room
        |> required "id" Decode.int
        |> required "name" Decode.string
        |> required "description" Decode.string
        |> required "player_count" Decode.int
