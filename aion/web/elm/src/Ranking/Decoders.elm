module Ranking.Decoders exposing (..)

import Json.Decode as Decode exposing (field, map, null, oneOf)
import Json.Decode.Pipeline exposing (decode, required)
import Ranking.Models exposing (PlayerScore, Ranking, CategoryRanking)


rankingDecoder : Decode.Decoder Ranking
rankingDecoder =
    decode Ranking
        |> required "rankingList" (Decode.list (categoryRankingDecoder))


categoryRankingDecoder : Decode.Decoder CategoryRanking
categoryRankingDecoder =
    decode CategoryRanking
        |> required "categoryId" Decode.int
        |> required "categoryName" Decode.string
        |> required "scores" (Decode.list (scoreDecoder))


scoreDecoder : Decode.Decoder PlayerScore
scoreDecoder =
    decode PlayerScore
        |> required "userName" Decode.string
        |> required "score" Decode.int
