module Update exposing (..)

import Dom exposing (focus)
import Forms
import General.Models exposing (Model, Route(RoomRoute))
import General.Utils exposing (getSubjectIdByName)
import Json.Decode as Decode
import Json.Encode as Encode
import Msgs exposing (Msg(..))
import Panel.Api exposing (createQuestionWithAnswers)
import Panel.Models exposing (questionFormPossibleFields)
import RemoteData
import Room.Constants exposing (enterKeyCode)
import Room.Decoders exposing (answerFeedbackDecoder, questionDecoder, usersListDecoder)
import Room.Models exposing (RoomsData, answerInputFieldId)
import Room.Notifications exposing (..)
import Routing exposing (parseLocation)
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push
import Task
import Toasty


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchRooms response ->
            { model | rooms = response } ! []

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
                        { model | panelData = { oldPanelData | questionForm = evenNewerQuestionForm } } ! []

                _ ->
                    model ! []

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                case newRoute of
                    RoomRoute roomId ->
                        let
                            roomIdToString =
                                toString roomId

                            channel =
                                Phoenix.Channel.init ("rooms:" ++ roomIdToString)

                            ( socket, cmd ) =
                                Phoenix.Socket.join channel
                                    (model.socket
                                        |> Phoenix.Socket.on "user:list" ("rooms:" ++ roomIdToString) ReceiveUserList
                                        |> Phoenix.Socket.on "new:question" ("rooms:" ++ roomIdToString) ReceiveQuestion
                                        |> Phoenix.Socket.on "answer:feedback" ("rooms:" ++ roomIdToString) ReceiveAnswerFeedback
                                    )
                        in
                            { model | socket = socket, route = newRoute, roomId = roomId, toasties = Toasty.initialState } ! [ Cmd.map PhoenixMsg cmd ]

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

        FocusResult result ->
            model ! []

        KeyDown key ->
            if key == enterKeyCode then
                update SubmitAnswer model
            else
                model ! []

        UpdateQuestionForm name value ->
            let
                oldPanelData =
                    model.panelData

                questionForm =
                    oldPanelData.questionForm
            in
                { model
                    | panelData =
                        { oldPanelData | questionForm = Forms.updateFormInput questionForm name value }
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
                    ( model, createQuestionWithAnswers model.panelData.questionForm model.rooms )
                else
                    model ! []

        NoOperation ->
            model ! []
