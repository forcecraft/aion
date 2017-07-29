module Update exposing (..)

import Dom exposing (focus)
import General.Models exposing (Model, Route(RoomRoute))
import General.Utils exposing (getSubjectIdByName)
import Json.Decode as Decode
import Msgs exposing (Msg(..))
import Panel.Api exposing (createQuestionWithAnswers)
import Room.Constants exposing (enterKeyCode)
import Room.Decoders exposing (answerFeedbackDecoder, questionDecoder, usersListDecoder)
import Room.Models exposing (RoomsData, answerInputFieldId)
import Routing exposing (parseLocation)
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push
import Json.Encode as Encode
import Task
import Room.Notifications exposing (..)
import Toasty


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchRooms response ->
            { model | rooms = response } ! []

        OnFetchCurrentUser response ->
            { model | user = response } ! []

        OnQuestionCreated response ->
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
                                "incorrect" -> incorrectAnswerToast
                                "close" -> closeAnswerToast
                                "correct" -> correctAnswerToast
                                _ -> Debug.crash "Unexpected Feedback"
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

        NoOperation ->
            model ! []

        ToastyMsg subMsg ->
            Toasty.update myConfig ToastyMsg subMsg model

        SetNewQuestionContent questionContent ->
            let
                oldPanelData =
                    model.panelData
            in
                { model | panelData = { oldPanelData | newQuestionContent = questionContent } } ! []

        SetNewAnswerContent answerContent ->
            let
                oldPanelData =
                    model.panelData
            in
                { model | panelData = { oldPanelData | newAnswerContent = answerContent } } ! []

        SetNewAnswerCategory answerCategoryName ->
            let
                answerCategoryToId =
                    getSubjectIdByName model.rooms answerCategoryName

                oldPanelData =
                    model.panelData
            in
                { model | panelData = { oldPanelData | newAnswerCategory = answerCategoryToId } } ! []

        CreateNewQuestionWithAnswers ->
            ( model, createQuestionWithAnswers model.panelData )
