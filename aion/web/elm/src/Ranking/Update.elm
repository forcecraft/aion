module General.Update exposing (..)

import General.Models exposing (Model)
import Multiselect
import Ranking.Msgs exposing (RankingMsg(OnFetchRanking, OnRankingCategoryChange))
import RemoteData


update : RankingMsg -> Model -> ( Model, Cmd RankingMsg )
update msg model =
    case msg of
        OnFetchRanking response ->
            let
                oldRankingData =
                    model.rankingData

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
                { model | rankingData = { oldRankingData | data = response, selectedCategoryId = selectedCategoryId } } ! []

        OnRankingCategoryChange response ->
            let
                oldRankingData =
                    model.rankingData

                newCategoryId =
                    case (String.toInt response) of
                        Ok result ->
                            result

                        _ ->
                            -1
            in
                { model | rankingData = { oldRankingData | selectedCategoryId = newCategoryId } } ! []
