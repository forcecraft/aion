module Ranking.Models exposing (..)

import Navigation exposing (Location)
import RemoteData exposing (WebData)


type alias RankingData =
    { data : WebData Ranking
    , selectedCategoryId : Int
    , location : Location
    }


initRankingData : Location -> RankingData
initRankingData location =
    { data = RemoteData.Loading
    , selectedCategoryId = -1
    , location = location
    }


type alias Ranking =
    { rankingList : List CategoryRanking }


type alias CategoryRanking =
    { categoryId : Int
    , categoryName : String
    , scores : List PlayerScore
    }


type alias PlayerScore =
    { userName : String
    , score : Int
    }
