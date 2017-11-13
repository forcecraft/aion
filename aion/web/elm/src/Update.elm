module Update exposing (..)

import Auth.Api exposing (registerUser, submitCredentials)
import Auth.Models exposing (Token, UnauthenticatedViewToggle(LoginView, RegisterView))
import Auth.Notifications exposing (loginErrorToast, registrationErrorToast)
import Dom exposing (focus)
import Forms
import General.Constants exposing (loginFormMsg, registerFormMsg)
import General.Models exposing (Model, Route(RankingRoute, RoomListRoute, RoomRoute), asEventLogIn)
import General.Notifications exposing (toastsConfig)
import Json.Decode as Decode
import Json.Encode as Encode
import Msgs exposing (Msg(..))
import Navigation exposing (Location, modifyUrl)
import Panel.Api exposing (createCategory, createQuestionWithAnswers, createRoom, fetchCategories)
import Panel.Models exposing (categoryNamePossibleFields, questionFormPossibleFields, roomNamePossibleFields)
import Panel.Notifications exposing (..)
import Ports exposing (check)
import Ranking.Api exposing (fetchRanking)
import RemoteData
import Room.Api exposing (fetchRooms)
import Room.Constants exposing (answerInputFieldId, enterKeyCode)
import Room.Decoders exposing (answerFeedbackDecoder, questionDecoder, questionSummaryDecoder, userJoinedInfoDecoder, userListMessageDecoder)
import Room.Models exposing (Event(MkQuestionSummaryLog, MkUserJoinedLog), EventLog, RoomState(QuestionBreak, QuestionDisplayed), asLogIn)
import Room.Notifications exposing (..)
import Routing exposing (parseLocation)
import Phoenix.Socket
import Task
import Toasty
import Multiselect
import Socket exposing (initSocket, initializeRoom, leaveRoom, sendAnswer)
import Urls exposing (host, websocketUrl)
import User.Api exposing (fetchCurrentUser)


updateForm : String -> String -> Forms.Form -> Forms.Form
updateForm name value form =
    Forms.updateFormInput form name value


unwrapToken : Maybe String -> String
unwrapToken token =
    case token of
        Just actualToken ->
            actualToken

        Nothing ->
            ""


setHomeUrl : Location -> Cmd Msg
setHomeUrl location =
    modifyUrl (host location)


postTokenActions : Token -> Location -> List (Cmd Msg)
postTokenActions token location =
    [ check token
    , fetchRooms location token
    , fetchCategories location token
    , fetchCurrentUser location token
    , setHomeUrl location
    ]



-- instead of calling "unwrap token" every time, this function will do it for you


withToken : Model -> (Token -> a) -> a
withToken model command =
    let
        token =
            unwrapToken model.authData.token
    in
        command token



-- instead of passing location you can just pass model to this function


withLocation : Model -> (Location -> a) -> a
withLocation model function =
    let
        location =
            model.location
    in
        function location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Login ->
            model
                ! [ submitCredentials model.location model.authData.loginForm ]

        LoginResult res ->
            let
                oldAuthData =
                    model.authData
            in
                case res of
                    Ok token ->
                        { model
                            | authData = { oldAuthData | token = Just token, msg = "" }
                            , socket = initSocket token model.location
                        }
                            ! postTokenActions token model.location

                    Err err ->
                        { model | authData = { oldAuthData | msg = toString err } }
                            ! []
                            |> loginErrorToast

        Register ->
            model ! [ registerUser model.location model.authData.registrationForm ]

        RegistrationResult response ->
            case response of
                RemoteData.Success responseData ->
                    let
                        token =
                            responseData.token

                        oldAuthData =
                            model.authData

                        oldRegistrationForm =
                            oldAuthData.registrationForm

                        newRegistrationForm =
                            updateForm "name" "" oldRegistrationForm
                                |> updateForm "email" ""
                                |> updateForm "password" ""
                    in
                        { model
                            | authData = { oldAuthData | registrationForm = newRegistrationForm, token = Just token }
                            , socket = initSocket token model.location
                        }
                            ! postTokenActions token model.location

                _ ->
                    model
                        ! []
                        |> registrationErrorToast

        Logout ->
            let
                oldAuthData =
                    model.authData
            in
                { model | authData = { oldAuthData | token = Nothing } } ! [ check "" ]

        ChangeAuthForm ->
            let
                oldAuthData =
                    model.authData

                oldUnauthenticatedView =
                    oldAuthData.unauthenticatedView
            in
                case oldUnauthenticatedView of
                    LoginView ->
                        { model
                            | authData =
                                { oldAuthData
                                    | unauthenticatedView = RegisterView
                                    , formMsg = registerFormMsg
                                }
                        }
                            ! []

                    RegisterView ->
                        { model
                            | authData =
                                { oldAuthData
                                    | unauthenticatedView = LoginView
                                    , formMsg = loginFormMsg
                                }
                        }
                            ! []

        OnFetchRooms response ->
            { model | rooms = response } ! []

        OnFetchRanking response ->
            { model | rankingData = response } ! []

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
                            Forms.updateFormInput oldCategoryForm "name" ""
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

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location

                ( newModel, afterLeaveCmd ) =
                    update LeaveRoom model
            in
                case newRoute of
                    RoomRoute roomId ->
                        let
                            ( initializeRoomSocket, initializeRoomCmd ) =
                                initializeRoom newModel.socket (toString roomId)
                        in
                            { newModel
                                | socket = initializeRoomSocket
                                , route = newRoute
                                , roomId = roomId
                                , toasties = Toasty.initialState
                            }
                                ! [ afterLeaveCmd
                                  , Cmd.map PhoenixMsg initializeRoomCmd
                                  ]

                    RoomListRoute ->
                        { newModel | route = newRoute }
                            ! [ afterLeaveCmd
                              , fetchRooms
                                    |> withLocation model
                                    |> withToken model
                              ]

                    RankingRoute ->
                        { model | route = newRoute }
                            ! [ afterLeaveCmd
                              , fetchRanking
                                    |> withLocation model
                                    |> withToken model
                              ]

                    _ ->
                        { newModel | route = newRoute } ! [ afterLeaveCmd ]

        LeaveRoom ->
            case model.route of
                RoomRoute id ->
                    let
                        ( leaveRoomSocket, leaveRoomCmd ) =
                            leaveRoom (toString id) model.socket
                    in
                        { model | socket = leaveRoomSocket } ! [ Cmd.map PhoenixMsg leaveRoomCmd ]

                _ ->
                    model ! []

        PhoenixMsg msg ->
            let
                ( socket, cmd ) =
                    Phoenix.Socket.update msg model.socket
            in
                { model | socket = socket } ! [ Cmd.map PhoenixMsg cmd ]

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
                        model
                            ! []
                            |> answerToast

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

                ( socket, cmd ) =
                    sendAnswer (toString model.roomId) payload model.socket
            in
                { model | socket = socket, userGameData = { currentAnswer = "" } } ! [ Cmd.map PhoenixMsg cmd ]

        ReceiveQuestion raw ->
            case Decode.decodeValue questionDecoder raw of
                Ok question ->
                    { model | currentQuestion = question } ! [ Task.attempt FocusResult (focus answerInputFieldId) ]

                Err error ->
                    model ! []

        ReceiveDisplayQuestion raw ->
            { model | roomState = QuestionDisplayed } ! []

        ReceiveQuestionBreak raw ->
            { model | roomState = QuestionBreak } ! []

        -- HTML
        FocusResult result ->
            model ! []

        KeyDown key ->
            if key == enterKeyCode then
                update SubmitAnswer model
            else
                model ! []

        -- Forms
        UpdateLoginForm name value ->
            let
                oldAuthData =
                    model.authData

                loginForm =
                    oldAuthData.loginForm

                updatedLoginForm =
                    Forms.updateFormInput loginForm name value
            in
                { model
                    | authData =
                        { oldAuthData | loginForm = updatedLoginForm }
                }
                    ! []

        UpdateRegistrationForm name value ->
            let
                oldAuthData =
                    model.authData

                registrationForm =
                    oldAuthData.registrationForm

                updatedRegistrationForm =
                    Forms.updateFormInput registrationForm name value
            in
                { model
                    | authData =
                        { oldAuthData | registrationForm = updatedRegistrationForm }
                }
                    ! []

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

        ReceiveUserJoined rawUserJoinedInfo ->
            case Decode.decodeValue userJoinedInfoDecoder rawUserJoinedInfo of
                Ok userJoinedInfo ->
                    let
                        oldEventLog =
                            model.eventLog

                        log =
                            case model.user of
                                RemoteData.Success currentUser ->
                                    { currentPlayer = currentUser.name
                                    , newPlayer = userJoinedInfo.user
                                    }
                                        |> MkUserJoinedLog
                                        |> asLogIn oldEventLog

                                _ ->
                                    oldEventLog
                    in
                        { model | eventLog = log } ! []

                Err error ->
                    model ! []

        ReceiveUserList raw ->
            case Decode.decodeValue userListMessageDecoder raw of
                Ok userListMessage ->
                    { model | userList = userListMessage.users } ! []

                Err error ->
                    model ! []

        ReceiveQuestionSummary raw ->
            case Decode.decodeValue questionSummaryDecoder raw of
                Ok questionSummary ->
                    (questionSummary
                        |> MkQuestionSummaryLog
                        |> asLogIn model.eventLog
                        |> asEventLogIn model
                    )
                        ! []

                Err error ->
                    model ! []
