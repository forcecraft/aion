module Ranking.Models exposing (..)


type alias RankingData =
    { data : List PlayerScore }


type alias PlayerScore =
    { userName : String
    , score : Int
    }
