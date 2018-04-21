module Ranking.Update exposing (..)

import Multiselect
import Ranking.Models exposing (RankingData)
import Ranking.Msgs exposing (RankingMsg(OnFetchRanking, OnRankingCategoryChange))
import RemoteData


update : RankingMsg -> RankingData -> ( RankingData, Cmd RankingMsg )
update msg model =
    case msg of
        OnFetchRanking response ->
            let
                rankingList =
                    case response of
                        RemoteData.Success data ->
                            data.rankingList

                        _ ->
                            []

                selectedCategoryId =
                    case (List.head rankingList) of
                        Just category ->
                            category.categoryId

                        _ ->
                            -1
            in
                { model | data = response, selectedCategoryId = selectedCategoryId } ! []

        OnRankingCategoryChange response ->
            let
                newCategoryId =
                    case (String.toInt response) of
                        Ok result ->
                            result

                        _ ->
                            -1
            in
                { model | selectedCategoryId = newCategoryId } ! []
