module Panel.Update exposing (..)

import Forms
import General.Models exposing (Model)
import Multiselect
import Panel.Api exposing (createCategory, createQuestionWithAnswers, createRoom)
import Panel.Models exposing (PanelData, categoryNamePossibleFields, questionFormPossibleFields)
import Panel.Msgs exposing (PanelMsg(CreateNewCategory, CreateNewQuestionWithAnswers, CreateNewRoom, MultiselectMsg, OnCategoryCreated, OnFetchCategories, OnQuestionCreated, OnRoomCreated, ToastyMsg, UpdateCategoryForm, UpdateQuestionForm, UpdateRoomForm))
import Panel.Notifications exposing (categoryCreationErrorToast, categoryCreationSuccessfulToast, categoryFormValidationErrorToast, questionCreationErrorToast, questionCreationSuccessfulToast, questionFormValidationErrorToast, roomCreationErrorToast, roomCreationSuccessfulToast, roomFormValidationErrorToast, toastsConfig)
import RemoteData
import Toasty
import UpdateHelpers exposing (unwrapToken, updateForm)


update : PanelMsg -> PanelData -> ( PanelData, Cmd PanelMsg )
update msg model =
    case msg of
        OnQuestionCreated response ->
            case response of
                RemoteData.Success responseData ->
                    let
                        newQuestionForm =
                            updateForm "question" "" model.questionForm
                                |> updateForm "answers" ""
                    in
                        { model | questionForm = newQuestionForm } ! [] |> questionCreationSuccessfulToast

                _ ->
                    model ! [] |> questionCreationErrorToast

        OnCategoryCreated response ->
            case response of
                RemoteData.Success responseData ->
                    let
                        newCategoryForm =
                            updateForm "name" "" model.categoryForm
                    in
                        { model | categoryForm = newCategoryForm } ! [] |> categoryCreationSuccessfulToast

                _ ->
                    model ! [] |> categoryCreationErrorToast

        OnRoomCreated response ->
            case response of
                RemoteData.Success responseData ->
                    let
                        newRoomForm =
                            updateForm "name" "" model.roomForm |> updateForm "description" ""
                    in
                        { model | roomForm = newRoomForm } ! [] |> roomCreationSuccessfulToast

                _ ->
                    model ! [] |> roomCreationErrorToast

        CreateNewCategory ->
            let
                token =
                    unwrapToken model.authData.token

                location =
                    model.location

                validationErrors =
                    categoryNamePossibleFields
                        |> List.map (\name -> Forms.errorList model.categoryForm name)
                        |> List.foldr (++) []
                        |> List.filter (\validations -> validations /= Nothing)
            in
                if List.isEmpty validationErrors then
                    model ! [ createCategory location token model.categoryForm ]
                else
                    model ! [] |> categoryFormValidationErrorToast

        CreateNewRoom ->
            let
                validationErrors =
                    []

                categoryIds =
                    List.map (\( id, _ ) -> id) (Multiselect.getSelectedValues model.panelData.categoryMultiSelect)

                token =
                    unwrapToken model.authData.token

                location =
                    model.location
            in
                if List.isEmpty validationErrors then
                    model ! [ createRoom location token model.roomForm categoryIds ]
                else
                    model ! [] |> roomFormValidationErrorToast

        UpdateQuestionForm name value ->
            let
                updatedQuestionForm =
                    Forms.updateFormInput model.questionForm name value
            in
                { model | questionForm = updatedQuestionForm } ! []

        UpdateCategoryForm name value ->
            let
                updatedCategoryForm =
                    Forms.updateFormInput model.categoryForm name value
            in
                { model | categoryForm = updatedCategoryForm } ! []

        UpdateRoomForm name value ->
            let
                updatedRoomForm =
                    Forms.updateFormInput model.roomForm name value
            in
                { model | roomForm = updatedRoomForm } ! []

        CreateNewQuestionWithAnswers ->
            let
                validationErrors =
                    questionFormPossibleFields
                        |> List.map (\name -> Forms.errorList model.questionForm name)
                        |> List.foldr (++) []
                        |> List.filter (\validations -> validations /= Nothing)

                token =
                    unwrapToken model.authData.token

                location =
                    model.location
            in
                if List.isEmpty validationErrors then
                    model ! [ createQuestionWithAnswers location token model.questionForm ]
                else
                    model ! [] |> questionFormValidationErrorToast

        OnFetchCategories response ->
            let
                categoryList =
                    case response of
                        RemoteData.Success categoriesData ->
                            List.map (\category -> ( toString (category.id), category.name )) categoriesData.data

                        _ ->
                            []

                updatedCategoryMultiselect =
                    Multiselect.initModel categoryList "id"
            in
                { model | categories = response, categoryMultiSelect = updatedCategoryMultiselect } ! []

        ToastyMsg subMsg ->
            Toasty.update toastsConfig ToastyMsg subMsg model

        MultiselectMsg subMsg ->
            let
                ( subModel, subCmd ) =
                    Multiselect.update subMsg model.panelData.categoryMultiSelect

                oldPanelData =
                    model.panelData
            in
                { model | categoryMultiSelect = subModel } ! [ Cmd.map MultiselectMsg subCmd ]
