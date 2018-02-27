module Panel.Update exposing (..)

import Forms
import General.Models exposing (Model)
import Msgs exposing (Msg(CreateNewCategory, CreateNewQuestionWithAnswers, CreateNewRoom, MultiselectMsg, OnCategoryCreated, OnQuestionCreated, OnRoomCreated, UpdateCategoryForm, UpdateLoginForm, UpdateQuestionForm, UpdateRegistrationForm, UpdateRoomForm))
import Multiselect
import Panel.Api exposing (createCategory, createQuestionWithAnswers, createRoom)
import Panel.Models exposing (categoryNamePossibleFields, questionFormPossibleFields)
import Panel.Notifications exposing (categoryCreationErrorToast, categoryCreationSuccessfulToast, categoryFormValidationErrorToast, questionCreationErrorToast, questionCreationSuccessfulToast, questionFormValidationErrorToast, roomCreationErrorToast, roomCreationSuccessfulToast, roomFormValidationErrorToast)
import RemoteData
import UpdateHelpers exposing (unwrapToken, updateForm)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnQuestionCreated response ->
            case response of
                RemoteData.Success responseData ->
                    let
                        oldPanelData =
                            model.panelData

                        oldQuestionForm =
                            model.panelData.questionForm

                        newQuestionForm =
                            updateForm "question" "" oldQuestionForm
                                |> updateForm "answers" ""
                    in
                        { model | panelData = { oldPanelData | questionForm = newQuestionForm } }
                            ! []
                            |> questionCreationSuccessfulToast

                _ ->
                    model
                        ! []
                        |> questionCreationErrorToast

        OnCategoryCreated response ->
            case response of
                RemoteData.Success responseData ->
                    let
                        oldPanelData =
                            model.panelData

                        oldCategoryForm =
                            model.panelData.categoryForm

                        newCategoryForm =
                            updateForm oldCategoryForm "name" ""
                    in
                        { model | panelData = { oldPanelData | categoryForm = newCategoryForm } }
                            ! []
                            |> categoryCreationSuccessfulToast

                _ ->
                    model
                        ! []
                        |> categoryCreationErrorToast

        OnRoomCreated response ->
            case response of
                RemoteData.Success responseData ->
                    let
                        oldPanelData =
                            model.panelData

                        oldRoomForm =
                            model.panelData.roomForm

                        newRoomForm =
                            updateForm "name" "" oldRoomForm
                                |> updateForm "description" ""
                    in
                        { model | panelData = { oldPanelData | roomForm = newRoomForm } }
                            ! []
                            |> roomCreationSuccessfulToast

                _ ->
                    model
                        ! []
                        |> roomCreationErrorToast

        CreateNewCategory ->
            let
                categoryForm =
                    model.panelData.categoryForm

                token =
                    unwrapToken model.authData.token

                location =
                    model.location

                validationErrors =
                    categoryNamePossibleFields
                        |> List.map (\name -> Forms.errorList categoryForm name)
                        |> List.foldr (++) []
                        |> List.filter (\validations -> validations /= Nothing)
            in
                if List.isEmpty validationErrors then
                    model ! [ createCategory location token categoryForm ]
                else
                    model
                        ! []
                        |> categoryFormValidationErrorToast

        CreateNewRoom ->
            let
                roomForm =
                    model.panelData.roomForm

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
                    model ! [ createRoom location token roomForm categoryIds ]
                else
                    model
                        ! []
                        |> roomFormValidationErrorToast

        UpdateQuestionForm name value ->
            let
                oldPanelData =
                    model.panelData

                questionForm =
                    oldPanelData.questionForm

                updatedQuestionForm =
                    Forms.updateFormInput questionForm name value
            in
                { model
                    | panelData =
                        { oldPanelData | questionForm = updatedQuestionForm }
                }
                    ! []

        UpdateCategoryForm name value ->
            let
                oldPanelData =
                    model.panelData

                categoryForm =
                    oldPanelData.categoryForm

                updatedCategoryForm =
                    Forms.updateFormInput categoryForm name value
            in
                { model
                    | panelData =
                        { oldPanelData | categoryForm = updatedCategoryForm }
                }
                    ! []

        UpdateRoomForm name value ->
            let
                panelData =
                    model.panelData

                oldRoomForm =
                    panelData.roomForm

                updatedRoomForm =
                    Forms.updateFormInput oldRoomForm name value
            in
                { model
                    | panelData =
                        { panelData | roomForm = updatedRoomForm }
                }
                    ! []

        CreateNewQuestionWithAnswers ->
            let
                questionForm =
                    model.panelData.questionForm

                validationErrors =
                    questionFormPossibleFields
                        |> List.map (\name -> Forms.errorList questionForm name)
                        |> List.foldr (++) []
                        |> List.filter (\validations -> validations /= Nothing)

                token =
                    unwrapToken model.authData.token

                location =
                    model.location

                rooms =
                    model.rooms
            in
                if List.isEmpty validationErrors then
                    model ! [ createQuestionWithAnswers location token questionForm rooms ]
                else
                    model
                        ! []
                        |> questionFormValidationErrorToast
