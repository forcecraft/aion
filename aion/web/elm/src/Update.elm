module Update exposing (..)

import Dom exposing (focus)
import Forms
import General.Models exposing (Model, Route(RoomRoute))
import General.Notifications exposing (toastsConfig)
import Json.Decode as Decode
import Json.Encode as Encode
import Msgs exposing (Msg(..))
import Panel.Api exposing (createCategory, createQuestionWithAnswers, createRoom)
import Panel.Models exposing (categoryNamePossibleFields, questionFormPossibleFields, roomNamePossibleFields)
import Panel.Notifications exposing (..)
import RemoteData
import Room.Constants exposing (answerInputFieldId, enterKeyCode)
import Room.Decoders exposing (answerFeedbackDecoder, questionDecoder, userJoinedInfoDecoder, usersListDecoder)
import Room.Notifications exposing (..)
import Routing exposing (parseLocation)
import Phoenix.Socket
import Phoenix.Push
import Task
import Toasty
import Multiselect
import Socket exposing (initializeRoom, leaveRoom)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchRooms response ->
            { model | rooms = response } ! []

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

        OnFetchCurrentUser response ->
            { model | user = response } ! []

        OnQuestionCreated response ->
            case response of
                RemoteData.Success responseData ->
                    let
                        oldPanelData =
                            model.panelData

                        oldQuestionForm =
                            model.panelData.questionForm

                        newQuestionForm =
                            Forms.updateFormInput oldQuestionForm "question" ""

                        evenNewerQuestionForm =
                            Forms.updateFormInput newQuestionForm "answers" ""
                    in
                        questionCreationSuccessfulToast ({ model | panelData = { oldPanelData | questionForm = evenNewerQuestionForm } } ! [])

                _ ->
                    questionCreationErrorToast (model ! [])

        OnCategoryCreated response ->
            case response of
                RemoteData.Success responseData ->
                    let
                        oldPanelData =
                            model.panelData

                        oldCategoryForm =
                            model.panelData.categoryForm

                        newCategoryForm =
                            Forms.updateFormInput oldCategoryForm "name" ""
                    in
                        categoryCreationSuccessfulToast ({ model | panelData = { oldPanelData | categoryForm = newCategoryForm } } ! [])

                _ ->
                    categoryCreationErrorToast (model ! [])

        OnRoomCreated response ->
            case response of
                RemoteData.Success responseData ->
                    let
                        oldPanelData =
                            model.panelData

                        oldRoomForm =
                            model.panelData.roomForm

                        newRoomForm =
                            Forms.updateFormInput oldRoomForm "name" ""

                        evenNewerRoomForm =
                            Forms.updateFormInput newRoomForm "description" ""
                    in
                        roomCreationSuccessfulToast ({ model | panelData = { oldPanelData | roomForm = evenNewerRoomForm } } ! [])

                _ ->
                    roomCreationErrorToast (model ! [])

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                case newRoute of
                    RoomRoute roomId ->
                        let
                            ( leaveRoomSocket, leaveRoomCmd ) =
                                leaveRoom (toString roomId) model.socket

                            ( initializeRoomSocket, initializeRoomCmd ) =
                                initializeRoom leaveRoomSocket (toString roomId)
                        in
                            { model
                                | socket = initializeRoomSocket
                                , route = newRoute
                                , roomId = roomId
                                , toasties = Toasty.initialState
                            }
                                ! [ Cmd.map PhoenixMsg initializeRoomCmd
                                  , Cmd.map PhoenixMsg leaveRoomCmd
                                  ]

                    _ ->
                        case model.route of
                            RoomRoute oldRoomId ->
                                let
                                    ( socket, cmd ) =
                                        leaveRoom (toString oldRoomId) model.socket
                                in
                                    { model | route = newRoute } ! [ Cmd.map PhoenixMsg cmd ]

                            _ ->
                                { model | route = newRoute } ! []

        PhoenixMsg msg ->
            let
                ( socket, cmd ) =
                    Phoenix.Socket.update msg model.socket
            in
                { model | socket = socket } ! [ Cmd.map PhoenixMsg cmd ]

        ReceiveUserList raw ->
            case Decode.decodeValue usersListDecoder raw of
                Ok usersInChannel ->
                    { model | usersInChannel = usersInChannel.users } ! []

                Err error ->
                    model ! []

        ReceiveAnswerFeedback rawFeedback ->
            case Decode.decodeValue answerFeedbackDecoder rawFeedback of
                Ok answerFeedback ->
                    let
                        answerToast =
                            case answerFeedback.feedback of
                                "incorrect" ->
                                    incorrectAnswerToast

                                "close" ->
                                    closeAnswerToast

                                "correct" ->
                                    correctAnswerToast

                                _ ->
                                    Debug.crash "Unexpected Feedback"
                    in
                        answerToast (model ! [])

                Err error ->
                    model ! []

        LeaveRoom roomId ->
            model ! []

        -- room join/leave
        ReceiveUserJoined rawUserJoinedInfo ->
            case Decode.decodeValue userJoinedInfoDecoder rawUserJoinedInfo of
                Ok userJoinedInfo ->
                    let
                        log =
                            case model.user of
                                RemoteData.Success currentUser ->
                                    if currentUser.name == userJoinedInfo.user then
                                        Debug.log currentUser.name "you have successfully joined the room!"
                                    else
                                        Debug.log userJoinedInfo.user "user joined."

                                _ ->
                                    ""
                    in
                        model ! []

                Err error ->
                    model ! []

        SetAnswer newAnswer ->
            { model | userGameData = { currentAnswer = newAnswer } } ! []

        SubmitAnswer ->
            let
                payload =
                    (Encode.object
                        [ ( "answer", Encode.string model.userGameData.currentAnswer )
                        , ( "room_id", Encode.string (toString model.roomId) )
                        ]
                    )

                push_ =
                    Phoenix.Push.init "new:answer" ("rooms:" ++ (toString model.roomId))
                        |> Phoenix.Push.withPayload payload
                        |> Phoenix.Push.onOk (\rawFeedback -> ReceiveAnswerFeedback rawFeedback)

                ( socket, cmd ) =
                    Phoenix.Socket.push push_ model.socket
            in
                { model | socket = socket } ! [ Cmd.map PhoenixMsg cmd ]

        ReceiveQuestion raw ->
            case Decode.decodeValue questionDecoder raw of
                Ok question ->
                    { model | questionInChannel = question, userGameData = { currentAnswer = "" } } ! [ Task.attempt FocusResult (focus answerInputFieldId) ]

                Err error ->
                    model ! []

        -- HTML
        FocusResult result ->
            model ! []

        KeyDown key ->
            if key == enterKeyCode then
                update SubmitAnswer model
            else
                model ! []

        -- Forms
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
            in
                if List.isEmpty validationErrors then
                    ( model, createQuestionWithAnswers model.location model.panelData.questionForm model.rooms )
                else
                    questionFormValidationErrorToast (model ! [])

        CreateNewCategory ->
            let
                categoryForm =
                    model.panelData.categoryForm

                validationErrors =
                    categoryNamePossibleFields
                        |> List.map (\name -> Forms.errorList categoryForm name)
                        |> List.foldr (++) []
                        |> List.filter (\validations -> validations /= Nothing)
            in
                if List.isEmpty validationErrors then
                    ( model, createCategory model.location model.panelData.categoryForm )
                else
                    categoryFormValidationErrorToast (model ! [])

        CreateNewRoom ->
            let
                roomForm =
                    model.panelData.roomForm

                validationErrors =
                    []

                categoryIds =
                    List.map (\( id, _ ) -> id) (Multiselect.getSelectedValues model.panelData.categoryMultiSelect)
            in
                if List.isEmpty validationErrors then
                    ( model, createRoom model.location model.panelData.roomForm categoryIds )
                else
                    roomFormValidationErrorToast (model ! [])

        MultiselectMsg subMsg ->
            let
                ( subModel, subCmd ) =
                    Multiselect.update subMsg model.panelData.categoryMultiSelect

                oldPanelData =
                    model.panelData
            in
                { model | panelData = { oldPanelData | categoryMultiSelect = subModel } } ! [ Cmd.map MultiselectMsg subCmd ]

        -- Toasty
        ToastyMsg subMsg ->
            Toasty.update toastsConfig ToastyMsg subMsg model

        -- Navbar
        NavbarMsg state ->
            ( { model | navbarState = state }, Cmd.none )

        -- NoOp
        NoOperation ->
            model ! []
