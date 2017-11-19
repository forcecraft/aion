module Ranking.Utils exposing (..)

import Ranking.Models exposing (PlayerScore, RankingData, CategoryRanking)


selectedCategoryScores : List CategoryRanking -> Int -> List PlayerScore
selectedCategoryScores rankingList selectedCategoryId =
    let
        selectedCategoryRanking =
            rankingList
                |> List.filter(\category -> category.categoryId == selectedCategoryId)
                |> List.head
    in
        case selectedCategoryRanking of
            Just x -> x.scores
            _ -> []


sortedScoresWithIndices : List PlayerScore -> List(Int, PlayerScore)
sortedScoresWithIndices scores =
    scores
        |> List.sortBy .score
        |> List.reverse
        |> List.indexedMap (,)
