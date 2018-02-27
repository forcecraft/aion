module Update exposing (..)

import Auth.Api exposing (registerUser, submitCredentials)
import Auth.Models exposing (Token, UnauthenticatedViewToggle(LoginView, RegisterView))
import Auth.Notifications exposing (loginErrorToast, registrationErrorToast)
import Dom exposing (focus)
import Forms
import General.Constants exposing (loginFormMsg, registerFormMsg)
import General.Models exposing (Model, Route(RankingRoute, UserRoute, RoomListRoute, RoomRoute), asEventLogIn, asProgressBarIn)
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
import Room.Constants exposing (answerInputFieldId, enterKeyCode, progressBarTimeout)
import Room.Decoders exposing (answerFeedbackDecoder, questionDecoder, questionSummaryDecoder, userJoinedInfoDecoder, userLeftDecoder, userListMessageDecoder)
import Room.Models exposing (Event(MkQuestionSummaryLog, MkUserJoinedLog, MkUserLeftLog), EventLog, ProgressBarState(Running, Stopped, Uninitialized), RoomState(QuestionBreak, QuestionDisplayed), asLogIn, withProgress, withRunning, withStart)
import Room.Notifications exposing (..)
import Room.Utils exposing (progressBarTick)
import Routing exposing (parseLocation)
import Phoenix.Socket
import Task
import Time exposing (inMilliseconds, millisecond)
import Toasty
import Multiselect
import Socket exposing (initSocket, initializeRoom, leaveRoom, sendAnswer)
import UpdateHelpers exposing (decodeAndUpdate, postTokenActions, updateForm, withLocation, withToken)
import Urls exposing (host, websocketUrl)
import User.Api exposing (fetchCurrentUser, fetchUserScores)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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
                                | eventLog = []
                                , route = newRoute
                                , roomId = roomId
                                , socket = initializeRoomSocket
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

                    UserRoute ->
                        { model | route = newRoute }
                            ! [ afterLeaveCmd
                              , fetchUserScores
                                    |> withLocation model
                                    |> withToken model
                              ]

                    _ ->
                        { newModel | route = newRoute } ! [ afterLeaveCmd ]

        PhoenixMsg msg ->
            let
                ( socket, cmd ) =
                    Phoenix.Socket.update msg model.socket
            in
                { model | socket = socket } ! [ Cmd.map PhoenixMsg cmd ]

        -- Toasty
        ToastyMsg subMsg ->
            Toasty.update toastsConfig ToastyMsg subMsg model

        -- Navbar
        NavbarMsg state ->
            { model | navbarState = state } ! []

        MultiselectMsg subMsg ->
            let
                ( subModel, subCmd ) =
                    Multiselect.update subMsg model.panelData.categoryMultiSelect

                oldPanelData =
                    model.panelData
            in
                { model | panelData = { oldPanelData | categoryMultiSelect = subModel } } ! [ Cmd.map MultiselectMsg subCmd ]
