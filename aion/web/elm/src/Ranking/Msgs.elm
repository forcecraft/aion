module Ranking.Msgs exposing (..)

import Ranking.Models exposing (Ranking)
import RemoteData exposing (WebData)


type RankingMsg
    = OnRankingCategoryChange String
    | OnFetchRanking (WebData Ranking)
