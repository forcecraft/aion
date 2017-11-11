module Ranking.View exposing (..)

import General.Models exposing (Model)
import Html exposing (..)
import Msgs exposing (Msg(..))
import Bootstrap.Table as Table
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Ranking.Models exposing (PlayerScore, RankingData)
import RemoteData exposing (WebData)


rankingView : Model -> Html Msg
rankingView model =
      Grid.container []
          [ Grid.row []
              [ Grid.col [ Col.xs4 ]
                  [ h4 []  [ text "General" ] ] ]
          , Grid.row []
              [ Grid.col [ Col.xs4 ]
                  [ rankingTable model ]
              ]
          ]


rankingTable : Model -> Html Msg
rankingTable model =
    Table.simpleTable
        ( Table.simpleThead
            [ Table.th [] [ text "User" ]
            , Table.th [] [ text "Score" ]
            ]
        , displayScores model.rankingData
        )


displayScores : WebData RankingData -> Table.TBody Msg
displayScores rankingData =
    case rankingData of
        RemoteData.Success rankingData ->
            let
                sortedScores = List.reverse (List.sortBy .score rankingData.data)
            in
                Table.tbody [] (List.map displaySingleScore sortedScores)
        _ ->
            Table.tbody [] []


displaySingleScore : PlayerScore -> Table.Row msg
displaySingleScore score =
    Table.tr []
        [ Table.td [] [ text score.userName ]
        , Table.td [] [ text (toString score.score) ]
        ]
