module Ranking.View exposing (..)

import General.Models exposing (Model)
import Html exposing (..)
import Html.Attributes exposing (style, src, value, class)
import Msgs exposing (Msg(..))
import Bootstrap.Table as Table
import Bootstrap.Grid as Grid
import Bootstrap.Table exposing (rowAttr)
import Bootstrap.Grid.Col as Col
import Bootstrap.Form as Form
import Bootstrap.Form.Select as Select
import Ranking.Models exposing (PlayerScore, RankingData, CategoryRanking)
import Ranking.Msgs exposing (RankingMsg(OnRankingCategoryChange))
import RemoteData exposing (WebData)
import Navigation exposing (Location)
import Ranking.Utils exposing (selectedCategoryScores, sortedScoresWithIndices)
import Ranking.Urls exposing (getGoldMedalImageUrl, getSilverMedalImageUrl, getBronzeMedalImageUrl)


rankingView : Model -> Html RankingMsg
rankingView model =
    Grid.container []
        [ Grid.row []
            [ Grid.col [ Col.xs4 ]
                [ Form.group []
                    [ Form.label [] [ text "Select Category" ]
                    , Select.select [ Select.onChange OnRankingCategoryChange ] (selectCategoriesAttributes model)
                    ]
                ]
            ]
        , Grid.row []
            [ Grid.col [ Col.xs12 ]
                [ rankingTable model ]
            ]
        ]


selectCategoriesAttributes : Model -> List (Select.Item msg)
selectCategoriesAttributes model =
    case model.rankingData.data of
        RemoteData.Success rankingData ->
            List.map displayCategoryOption rankingData.rankingList

        _ ->
            []


displayCategoryOption : CategoryRanking -> Select.Item msg
displayCategoryOption category =
    Select.item [ value (toString category.categoryId) ] [ text category.categoryName ]


rankingTable : Model -> Html RankingMsg
rankingTable model =
    Table.table
        { options = [ Table.striped, Table.hover ]
        , thead =
            Table.simpleThead
                [ Table.th [] [ text "#" ]
                , Table.th [ Table.cellAttr (class "medalColumn") ] []
                , Table.th [] [ text "User" ]
                , Table.th [] [ text "Score" ]
                ]
        , tbody = displayScores model
        }


displayScores : Model -> Table.TBody RankingMsg
displayScores model =
    case model.rankingData.data of
        RemoteData.Success rankingData ->
            let
                categoryScores =
                    selectedCategoryScores rankingData.rankingList model.rankingData.selectedCategoryId
            in
                Table.tbody [] (List.map (displaySingleScore model) (sortedScoresWithIndices categoryScores))

        _ ->
            Table.tbody [] []


displaySingleScore : Model -> ( Int, PlayerScore ) -> Table.Row RankingMsg
displaySingleScore model indexAndScore =
    case indexAndScore of
        ( index, playerScore ) ->
            Table.tr []
                [ Table.td [] [ text (toString (index + 1)) ]
                , Table.td [] (scoreImage model.location index)
                , Table.td [] [ text playerScore.userName ]
                , Table.td [] [ text (toString playerScore.score) ]
                ]


scoreImage : Navigation.Location -> Int -> List (Html RankingMsg)
scoreImage location index =
    case index of
        0 ->
            [ img [ src (getGoldMedalImageUrl location) ] [] ]

        1 ->
            [ img [ src (getSilverMedalImageUrl location) ] [] ]

        2 ->
            [ img [ src (getBronzeMedalImageUrl location) ] [] ]

        _ ->
            []
