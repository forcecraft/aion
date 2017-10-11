module Update exposing (..)

import Auth.Api exposing (registerUser, submitCredentials)
import Auth.Notifications exposing (..)
import Dom exposing (focus)
import Forms
import General.Constants exposing (loginFormMsg, registerFormMsg)
import General.Models exposing (Model, Route(RoomRoute))
import General.Notifications exposing (toastsConfig)
import Json.Decode as Decode
import Json.Encode as Encode
import Msgs exposing (Msg(..))
import Panel.Api exposing (createCategory, createQuestionWithAnswers, createRoom, fetchCategories)
import Panel.Models exposing (categoryNamePossibleFields, questionFormPossibleFields, roomNamePossibleFields)
import Panel.Notifications exposing (..)
import Ports exposing (check)
import RemoteData
import Room.Api exposing (fetchRooms)
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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Login ->
            model ! [ submitCredentials model.authData.loginForm ]

        LoginResult res ->
            let
                oldAuthData =
                    model.authData
            in
                case res of
                    Ok token ->
                        { model
                            | authData = { oldAuthData | token = Just token, msg = "" }
                            , socket =
                                Phoenix.Socket.init ("ws://localhost:4000/socket/websocket?token=" ++ token)
                                    |> Phoenix.Socket.withDebug
                        }
                            ! [ check token
                              , fetchRooms token
                              , fetchCategories token
                              , fetchCurrentUser token
                              ]

                    Err err ->
                        { model | authData = { oldAuthData | msg = toString err } } ! []

        Register ->
            model ! [ registerUser model.authData.registrationForm ]

        RegistrationResult response ->
            case response of
                RemoteData.Success responseData ->
                    let
                        oldAuthData =
                            model.authData

                        oldRegistrationForm =
                            oldAuthData.registrationForm

                        newRegistrationForm =
                            updateForm "name" "" oldRegistrationForm
                                |> updateForm "email" ""
                                |> updateForm "password" ""
                    in
                        { model | authData = { oldAuthData | registrationForm = newRegistrationForm } }
                            ! []
                            |> registrationSuccessfulToast

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

                oldDisplayLoginInsteadOfRegistration =
                    oldAuthData.displayLoginInsteadOfRegistration
            in
                case oldDisplayLoginInsteadOfRegistration of
                    True ->
                        { model
                            | authData =
                                { oldAuthData
                                    | displayLoginInsteadOfRegistration = False
                                    , formMsg = registerFormMsg
                                }
                        }
                            ! []

                    False ->
                        { model
                            | authData =
                                { oldAuthData
                                    | displayLoginInsteadOfRegistration = True
                                    , formMsg = loginFormMsg
                                }
                        }
                            ! []

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
                        model
                            ! []
                            |> answerToast

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

                rooms =
                    model.rooms
            in
                if List.isEmpty validationErrors then
                    model ! [ createQuestionWithAnswers token questionForm rooms ]
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

                validationErrors =
                    categoryNamePossibleFields
                        |> List.map (\name -> Forms.errorList categoryForm name)
                        |> List.foldr (++) []
                        |> List.filter (\validations -> validations /= Nothing)
            in
                if List.isEmpty validationErrors then
                    model ! [ createCategory token categoryForm ]
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
            in
                if List.isEmpty validationErrors then
                    model ! [ createRoom token roomForm categoryIds ]
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
