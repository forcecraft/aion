module Ranking.Api exposing (..)

import Auth.Models exposing (Token)
import Http exposing (Request)
import Json.Decode as Decode
import Navigation exposing (Location)
import Ranking.Decoders exposing (rankingDecoder)
import Ranking.Models exposing (Ranking, CategoryRanking)
import Ranking.Msgs exposing (RankingMsg(OnFetchRanking))
import RemoteData
import Urls exposing (rankingUrl)


fetchRankingRequest : String -> String -> Decode.Decoder Ranking -> Request Ranking
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


fetchRanking : Location -> Token -> Cmd RankingMsg
fetchRanking location token =
    let
        url =
            rankingUrl location
    in
        fetchRankingRequest url token rankingDecoder
            |> RemoteData.sendRequest
            |> Cmd.map OnFetchRanking
