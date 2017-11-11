module Ranking.Api exposing (..)

import Auth.Models exposing (Token)
import Http exposing (Request)
import Json.Decode as Decode
import Msgs exposing (Msg)
import Navigation exposing (Location)
import Ranking.Decoders exposing (rankingDecoder)
import Ranking.Models exposing (RankingData)
import RemoteData
import Urls exposing (rankingUrl)


fetchRankingRequest : String -> String -> Decode.Decoder RankingData -> Request RankingData
fetchRankingRequest url token decoder =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ token) ]
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = True
        }


fetchRanking : Location -> Token -> Cmd Msg
fetchRanking location token =
    let
        url =
            rankingUrl location
    in
        fetchRankingRequest url token rankingDecoder
            |> RemoteData.sendRequest
            |> Cmd.map Msgs.OnFetchRanking
