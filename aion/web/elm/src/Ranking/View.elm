module Ranking.View exposing (..)

import General.Models exposing (Model)
import Html exposing (..)
import Msgs exposing (Msg(..))
import Material.Table as Table
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Ranking.Models exposing (RankingData)
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
    Table.table []
        [ Table.thead []
            [ Table.tr []
                [ Table.th [] [ text "User" ]
                , Table.th [] [ text "Score" ]
              ]
            ]
        , Table.tbody [] (scores model.rankingData)
        ]


scores : WebData RankingData -> List(Html Msg)
scores rankingData =
    case rankingData of
        RemoteData.Success rankingData ->
            rankingData.data |>
              List.map(\e ->
                 Table.tr []
                   [ Table.td [] [ text e.userName ]
                   , Table.td [ Table.numeric ] [ text (toString e.score) ]
                   ])
        _ ->
            []
