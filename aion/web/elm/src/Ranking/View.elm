module Ranking.View exposing (..)

import General.Models exposing (Model)
import Html exposing (..)
import Html.Attributes exposing(style, src, value)
import Msgs exposing (Msg(..))
import Bootstrap.Table as Table
import Bootstrap.Grid as Grid
import Bootstrap.Table exposing(rowAttr)
import Bootstrap.Grid.Col as Col
import Bootstrap.Form as Form
import Bootstrap.Form.Select as Select
import Ranking.Models exposing (PlayerScore, RankingData, CategoryRanking)
import RemoteData exposing (WebData)
import Urls exposing (host)
import Navigation exposing (Location)


rankingView : Model -> Html Msg
rankingView model =
    Grid.container []
        [ Grid.row []
            [ Grid.col [ Col.xs4, Col.offsetXs1 ]
                [ Form.group []
                    [ Form.label [] [ text "Select Category" ]
                    , Select.select [ Select.onChange OnRankingCategoryChange ] (selectCategoriesAttributes model)
                    ]
                ]
            ]
        , Grid.row []
            [ Grid.col [ Col.xs10, Col.offsetXs1 ]
                [ rankingTable model ]
            ]
        ]


selectCategoriesAttributes : Model -> List (Select.Item msg)
selectCategoriesAttributes model =
    case model.rankingData.data of
        RemoteData.Success rankingData ->
            List.map (\category -> Select.item [ value (toString category.categoryId) ] [ text category.categoryName] ) rankingData.rankingList
        _ -> []


rankingTable : Model -> Html Msg
rankingTable model =
    Table.table
        { options = [ Table.striped, Table.hover ]
        , thead = Table.simpleThead
            [ Table.th [] [ text "#" ]
            , Table.th [ Table.cellAttr(style [ ("width", "5%") ]) ] []
            , Table.th [] [ text "User" ]
            , Table.th [] [ text "Score" ]
            ]
        , tbody = displayScores model
        }


displayScores : Model -> Table.TBody Msg
displayScores model =
    case model.rankingData.data of
        RemoteData.Success rankingData ->
            let
                categoryScores = selectedCategoryScores rankingData.rankingList model.rankingData.selectedCategoryId
            in
                Table.tbody [] (List.map (displaySingleScore model) (sortedScoresWithIndices categoryScores))

        _ ->
            Table.tbody [] []


displaySingleScore : Model -> (Int, PlayerScore) -> Table.Row msg
displaySingleScore model indexAndScore =
    case indexAndScore of
        (index, playerScore) ->
            Table.tr []
                [ Table.td [] [ text (toString (index + 1)) ]
                , Table.td [] (scoreImage model.location index)
                , Table.td [] [ text playerScore.userName ]
                , Table.td [] [ text (toString playerScore.score) ]
                ]


scoreImage : Navigation.Location -> Int -> List (Html msg)
scoreImage location index =
    let
        commonPath = (host location) ++ "images/"
        imagePath = case index of
                        0 -> "medal_gold.png"
                        1 -> "medal_silver.png"
                        2 -> "medal_bronze.png"
                        _ -> ""
    in
        case imagePath of
            "" -> []
            _ -> [ img [ src (commonPath ++ imagePath) ] [] ]


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
