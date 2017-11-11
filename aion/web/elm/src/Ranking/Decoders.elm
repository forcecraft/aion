module Ranking.Decoders exposing (..)

import Json.Decode as Decode exposing (field, map, null, oneOf)
import Json.Decode.Pipeline exposing (decode, required)
import Ranking.Models exposing (PlayerScore, RankingData)


rankingDecoder : Decode.Decoder RankingData
rankingDecoder =
    decode RankingData
        |> required "data" (Decode.list (scoreDecoder))


scoreDecoder : Decode.Decoder PlayerScore
scoreDecoder =
    decode PlayerScore
        |> required "userName" Decode.string
        |> required "score" Decode.int
