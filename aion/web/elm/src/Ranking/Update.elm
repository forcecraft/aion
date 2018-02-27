module General.Update exposing (..)

import General.Models exposing (Model)
import Msgs exposing (Msg(OnFetchCategories, OnFetchRanking, OnRankingCategoryChange))
import Multiselect
import RemoteData


update : Msg -> Model -> ( Model, Cmd Msg )
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

        OnFetchCategories response ->
            let
                newModel =
                    { model | categories = response }

                categoryList =
                    case newModel.categories of
                        RemoteData.Success categoriesData ->
                            List.map (\category -> ( toString (category.id), category.name )) categoriesData.data

                        _ ->
                            []

                oldPanelData =
                    model.panelData

                updatedCategoryMultiselect =
                    Multiselect.initModel categoryList "id"
            in
                { newModel | panelData = { oldPanelData | categoryMultiSelect = updatedCategoryMultiselect } } ! []
