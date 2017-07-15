module Update exposing (..)

import Dom exposing (focus)
import General.Models exposing (Model, Route(RoomRoute))
import Json.Decode as Decode
import Msgs exposing (Msg(..))
import Room.Decoders exposing (answerFeedbackDecoder, questionDecoder, usersListDecoder)
import Room.Constants exposing (enterKeyCode)
import Room.Models exposing (answerInputFieldId)
import Routing exposing (parseLocation)
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push
import Json.Encode as Encode
import Task


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchRooms response ->
            { model | rooms = response } ! []

        OnFetchCurrentUser response ->
            { model | user = response } ! []

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
                            { model | socket = socket, route = newRoute, roomId = roomId } ! [ Cmd.map PhoenixMsg cmd ]

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
                        x =
                            Debug.log "feedback" answerFeedback.feedback
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

        SetNewQuestionContent questionContent ->
            let
                oldPanelData =
                    model.panelData

                newPanelData =
                    { oldPanelData | newQuestionContent = questionContent }
            in
                { model | panelData = newPanelData } ! []

        SetNewAnswerContent answerContent ->
            let
                oldPanelData =
                    model.panelData

                newPanelData =
                    { oldPanelData | newAnswerContent = answerContent }
            in
                { model | panelData = newPanelData } ! []

        CreateNewQuestionWithAnswers ->
            model ! []
