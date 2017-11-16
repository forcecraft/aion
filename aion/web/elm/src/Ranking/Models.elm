module Ranking.Models exposing (..)

import RemoteData exposing (WebData)


type alias RankingData =
    { data : WebData Ranking
    , selectedCategoryId : Int
    }


type alias Ranking =
    { rankingList: List CategoryRanking }


type alias CategoryRanking =
    { categoryId : Int
    , categoryName : String
    , scores: List PlayerScore
    }


type alias PlayerScore =
    { userName : String
    , score : Int
    }
