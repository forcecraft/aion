module Update exposing (..)

import Auth.Api exposing (registerUser, submitCredentials)
import Auth.Models exposing (Token, UnauthenticatedViewToggle(LoginView, RegisterView))
import Auth.Msgs exposing (AuthMsg(LoginResult, RegistrationResult))
import Auth.Notifications exposing (loginErrorToast, registrationErrorToast)
import Auth.Update
import Dom exposing (focus)
import Forms
import General.Constants exposing (loginFormMsg, registerFormMsg)
import General.Models exposing (Model, Route(RankingRoute, UserRoute, RoomListRoute, RoomRoute), asEventLogIn, asProgressBarIn)
import General.Update
import Json.Decode as Decode
import Json.Encode as Encode
import Msgs exposing (Msg(..))
import Navigation exposing (Location, modifyUrl)
import Panel.Api exposing (createCategory, createQuestionWithAnswers, createRoom, fetchCategories)
import Panel.Models exposing (categoryNamePossibleFields, questionFormPossibleFields, roomNamePossibleFields)
import Panel.Notifications exposing (..)
import Panel.Update
import Ports exposing (check)
import Ranking.Api exposing (fetchRanking)
import Ranking.Msgs exposing (RankingMsg)
import Ranking.Update
import RemoteData
import Room.Api exposing (fetchRooms)
import Room.Constants exposing (answerInputFieldId, enterKeyCode, progressBarTimeout)
import Room.Decoders exposing (answerFeedbackDecoder, questionDecoder, questionSummaryDecoder, userJoinedInfoDecoder, userLeftDecoder, userListMessageDecoder)
import Room.Models exposing (Event(MkQuestionSummaryLog, MkUserJoinedLog, MkUserLeftLog), EventLog, ProgressBarState(Running, Stopped, Uninitialized), RoomState(QuestionBreak, QuestionDisplayed), asLogIn, withProgress, withRunning, withStart)
import Room.Msgs exposing (RoomMsg(PhoenixMsg))
import Room.Notifications exposing (..)
import Room.Update
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
import User.Msgs exposing (UserMsg)
import User.Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        --sub-modules
        MkRoomMsg subMsg ->
            let
                ( updatedModel, cmd ) =
                    Room.Update.update subMsg model
            in
                updatedModel ! [ Cmd.map MkRoomMsg cmd ]

        MkUserMsg subMsg ->
            let
                ( updatedModel, cmd ) =
                    User.Update.update subMsg model
            in
                updatedModel ! [ Cmd.map MkUserMsg cmd ]

        MkRankingMsg subMsg ->
            let
                ( updatedModel, cmd ) =
                    Ranking.Update.update subMsg model
            in
                updatedModel ! [ Cmd.map MkRankingMsg cmd ]

        MkPanelMsg subMsg ->
            let
                ( updatedModel, cmd ) =
                    Panel.Update.update subMsg model
            in
                updatedModel ! [ Cmd.map MkPanelMsg cmd ]

        MkGeneralMsg subMsg ->
            let
                ( updatedModel, cmd ) =
                    General.Update.update subMsg model
            in
                updatedModel ! [ Cmd.map MkGeneralMsg cmd ]

        MkAuthMsg subMsg ->
            let
                ( updatedModel, cmd ) =
                    Auth.Update.update subMsg model

                extraCmds =
                    case subMsg of
                        LoginResult (Ok token) ->
                            postTokenActions token model.location

                        RegistrationResult (RemoteData.Success response) ->
                            postTokenActions response.token model.location

                        _ ->
                            []
            in
                updatedModel
                    ! ([ Cmd.map MkAuthMsg cmd ] ++ extraCmds)

        --the rest
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
                                  , initializeRoomCmd
                                        |> Cmd.map PhoenixMsg
                                        |> Cmd.map MkRoomMsg
                                  ]

                    RoomListRoute ->
                        { newModel | route = newRoute }
                            ! [ afterLeaveCmd
                              , fetchRooms
                                    |> withLocation model
                                    |> withToken model
                                    |> Cmd.map MkGeneralMsg
                              ]

                    RankingRoute ->
                        { model | route = newRoute }
                            ! [ afterLeaveCmd
                              , fetchRanking
                                    |> withLocation model
                                    |> withToken model
                                    |> Cmd.map MkRankingMsg
                              ]

                    UserRoute ->
                        { model | route = newRoute }
                            ! [ afterLeaveCmd
                              , fetchUserScores
                                    |> withLocation model
                                    |> withToken model
                                    |> Cmd.map MkUserMsg
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
                        { model | socket = leaveRoomSocket }
                            ! [ leaveRoomCmd
                                    |> Cmd.map PhoenixMsg
                                    |> Cmd.map MkRoomMsg
                              ]

                _ ->
                    model ! []

        -- Navbar
        NavbarMsg state ->
            { model | navbarState = state } ! []
