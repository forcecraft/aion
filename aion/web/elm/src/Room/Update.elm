module Room.Update exposing (..)

import Dom exposing (focus)
import General.Models exposing (Model, Route(RoomRoute), asEventLogIn, asProgressBarIn)
import Msgs exposing (Msg(FocusResult, KeyDown, LeaveRoom, OnInitialTime, OnTime, PhoenixMsg, ReceiveAnswerFeedback, ReceiveDisplayQuestion, ReceiveQuestion, ReceiveQuestionBreak, ReceiveQuestionSummary, ReceiveUserJoined, ReceiveUserLeft, ReceiveUserList, SetAnswer, SubmitAnswer, Tick))
import RemoteData
import Room.Constants exposing (answerInputFieldId, enterKeyCode)
import Room.Decoders exposing (answerFeedbackDecoder, questionDecoder, questionSummaryDecoder, userJoinedInfoDecoder, userLeftDecoder, userListMessageDecoder)
import Room.Models exposing (Event(MkQuestionSummaryLog, MkUserJoinedLog, MkUserLeftLog), ProgressBarState(Running, Stopped, Uninitialized), RoomState(QuestionBreak, QuestionDisplayed), asLogIn, withProgress, withRunning, withStart)
import Room.Notifications exposing (closeAnswerToast, correctAnswerToast, incorrectAnswerToast)
import Room.Utils exposing (progressBarTick)
import UpdateHelpers exposing (decodeAndUpdate)
import Json.Encode as Encode
import Socket exposing (leaveRoom, sendAnswer)
import Task
import Time exposing (inMilliseconds)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceiveUserList raw ->
            decodeAndUpdate raw
                userListMessageDecoder
                model
                (\userListMessage ->
                    { model | userList = userListMessage.users } ! []
                )

        ReceiveAnswerFeedback rawFeedback ->
            decodeAndUpdate rawFeedback
                answerFeedbackDecoder
                model
                (\answerFeedback ->
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
                )

        ReceiveUserJoined rawUserJoinedInfo ->
            decodeAndUpdate rawUserJoinedInfo
                userJoinedInfoDecoder
                model
                (\userJoinedInfo ->
                    let
                        oldEventLog =
                            model.eventLog

                        log =
                            case model.user.details of
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
                )

        ReceiveUserLeft rawUserLeftInfo ->
            decodeAndUpdate rawUserLeftInfo
                userLeftDecoder
                model
                (\userLeftInfo ->
                    (userLeftInfo
                        |> MkUserLeftLog
                        |> asLogIn model.eventLog
                        |> asEventLogIn model
                    )
                        ! []
                )

        ReceiveQuestionSummary rawQuestionSummary ->
            decodeAndUpdate rawQuestionSummary
                questionSummaryDecoder
                model
                (\questionSummary ->
                    (questionSummary
                        |> MkQuestionSummaryLog
                        |> asLogIn model.eventLog
                        |> asEventLogIn model
                    )
                        ! []
                )

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
            decodeAndUpdate raw
                questionDecoder
                model
                (\question ->
                    { model | currentQuestion = question }
                        ! [ Task.attempt FocusResult (focus answerInputFieldId) ]
                )

        ReceiveDisplayQuestion _ ->
            { model
                | roomState = QuestionDisplayed
                , progressBar = model.progressBar |> withProgress 0 |> withRunning Uninitialized |> withStart 0
            }
                ! []

        ReceiveQuestionBreak raw ->
            { model
                | roomState = QuestionBreak
                , progressBar = model.progressBar |> withRunning Stopped
            }
                ! []

        -- HTML
        FocusResult result ->
            model ! []

        KeyDown key ->
            if key == enterKeyCode then
                update SubmitAnswer model
            else
                model ! []

        Tick time ->
            case model.progressBar.running of
                Uninitialized ->
                    update (OnInitialTime time) model

                Running ->
                    update (OnTime time) model

                Stopped ->
                    model ! []

        OnInitialTime time ->
            update
                (OnTime time)
                (model.progressBar
                    |> withStart (inMilliseconds time)
                    |> withRunning Running
                    |> asProgressBarIn model
                )

        OnTime time ->
            let
                progressBar =
                    case model.progressBar.running of
                        Running ->
                            progressBarTick model.progressBar time

                        _ ->
                            model.progressBar
            in
                (progressBar |> asProgressBarIn model) ! []

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

        -- NoOp
        NoOperation ->
            model ! []
