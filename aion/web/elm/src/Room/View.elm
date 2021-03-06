module Room.View exposing (..)

import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.ListGroup as ListGroup
import Bootstrap.Progress as Progress
import Html exposing (Attribute, Html, a, button, div, form, h4, hr, input, li, text, ul)
import Html.Attributes exposing (autocomplete, class, for, href, id, src, value)
import Html.Events exposing (keyCode, on, onClick, onInput, onWithOptions)
import Json.Decode exposing (map)
import Lobby.Models exposing (RoomId)
import Html exposing (Html, a, div, img, li, p, text, ul)
import Navigation exposing (Location)
import Room.Constants exposing (answerInputFieldId, defaultImagePath, imagesPath)
import Room.Models exposing (Answer, Event(MkQuestionSummaryLog, MkUserJoinedLog, MkUserLeftLog), EventLog, ImageName, ProgressBar, ProgressBarState(Stopped), RoomData, RoomState(QuestionBreak, QuestionDisplayed), UserGameData, UserRecord)
import Room.Msgs exposing (RoomMsg(SetAnswer, SubmitAnswer, ToastyMsg))
import Room.Notifications exposing (toastsConfig)
import Room.Urls exposing (getImageUrl)
import Toasty
import Toasty.Defaults


roomView : RoomData -> RoomId -> Html RoomMsg
roomView model roomId =
    let
        currentAnswer =
            model.userGameData.currentAnswer
    in
        Grid.container [ class "room-container" ]
            [ Grid.row []
                [ Grid.col [ Col.sm7 ]
                    [ displayQuestionText model
                    , displayProgress model.progressBar
                    , displayAnswerInput currentAnswer
                    ]
                , Grid.col [ Col.sm5 ]
                    [ displayQuestionImage model.location model.currentQuestion.image_name model.roomState
                    ]
                ]
            , hr [ class "room-content-separator" ] []
            , Grid.row [ Row.attrs [ class "room-lower-content" ] ]
                [ Grid.col [ Col.sm7 ]
                    [ displayEventLog model.eventLog
                    ]
                , Grid.col [ Col.sm5 ]
                    [ displayScores model
                    ]
                ]
            , Toasty.view toastsConfig Toasty.Defaults.view ToastyMsg model.toasties
            ]


displayProgress : ProgressBar -> Html RoomMsg
displayProgress progress =
    let
        optionalAttrs =
            case progress.running of
                Stopped ->
                    [ Progress.animated ]

                _ ->
                    []
    in
        div [ class "progress-bar" ]
            [ Progress.progress <|
                [ Progress.success
                , Progress.value progress.progress
                ]
                    ++ optionalAttrs
            ]


displayEventLog : EventLog -> Html RoomMsg
displayEventLog eventLog =
    let
        logList =
            eventLog
                |> List.take 5
                |> List.map displaySingleLog
    in
        div
            [ class "room-events" ]
            [ ListGroup.ul logList ]


displaySingleLog : Event -> ListGroup.Item msg
displaySingleLog event =
    let
        log =
            case event of
                MkUserJoinedLog userJoinedLog ->
                    userJoinedLog ++ " joined the room."

                MkUserLeftLog userLeftLog ->
                    userLeftLog.user ++ " left."

                MkQuestionSummaryLog questionSummaryLog ->
                    let
                        winnerAnnouncement =
                            case questionSummaryLog.winner of
                                "" ->
                                    ""

                                winner ->
                                    winner ++ " was the first one to answer correctly! "
                    in
                        winnerAnnouncement
                            ++ "The correct answers were: "
                            ++ String.join ", "
                                questionSummaryLog.answers
    in
        ListGroup.li [] [ text log ]


displayQuestionText : RoomData -> Html RoomMsg
displayQuestionText model =
    div [ class "question-container" ]
        [ displayQuestion model.currentQuestion.content model.roomState
        ]


displayScores : RoomData -> Html RoomMsg
displayScores model =
    div
        [ class "room-scoreboard" ]
        [ ListGroup.ul (List.map displaySingleScore model.userList) ]


displaySingleScore : UserRecord -> ListGroup.Item msg
displaySingleScore userRecord =
    let
        percentage =
            toString (userRecord.score * 100 // userRecord.questionsAsked)

        score =
            toString userRecord.score

        total =
            toString userRecord.questionsAsked

        fieldValue =
            userRecord.name ++ ": " ++ score ++ " of " ++ total ++ " (" ++ percentage ++ "%)"
    in
        ListGroup.li [] [ text fieldValue ]


displayQuestion : String -> RoomState -> Html RoomMsg
displayQuestion question roomState =
    let
        temporaryText =
            "Get ready, the next question is going to appear soon!"

        textFieldValue =
            case roomState of
                QuestionDisplayed ->
                    question

                QuestionBreak ->
                    temporaryText
    in
        div [ class "room-question-container" ]
            [ p [ class "room-question" ] [ text textFieldValue ]
            ]


displayQuestionImage : Location -> ImageName -> RoomState -> Html RoomMsg
displayQuestionImage location imageName roomState =
    let
        questionImageSource =
            getImageUrl location imageName

        imageSource =
            case roomState of
                QuestionDisplayed ->
                    questionImageSource

                QuestionBreak ->
                    "https://i.ytimg.com/vi/NjlzcriYc8o/maxresdefault.jpg"

        hiddenImageSource =
            case roomState of
                QuestionDisplayed ->
                    ""

                QuestionBreak ->
                    questionImageSource
    in
        div []
            [ img [ class "room-image", src imageSource ] []
            , img [ class "room-image-hidden", src hiddenImageSource ] []
            ]


displayAnswerInput : Answer -> Html RoomMsg
displayAnswerInput currentAnswer =
    Form.form [ class "room-answer-input" ]
        [ Form.group []
            [ Grid.row []
                [ Grid.col [ Col.sm9 ] [ displayAnswerInputField currentAnswer ]
                , Grid.col [ Col.sm3 ] [ displayAnswerSubmitButton ]
                ]
            ]
        ]


displayAnswerInputField : Answer -> Html RoomMsg
displayAnswerInputField currentAnswer =
    Input.text
        [ Input.attrs [ autocomplete False ]
        , Input.id answerInputFieldId
        , Input.onInput SetAnswer
        , Input.value currentAnswer
        ]


displayAnswerSubmitButton : Html RoomMsg
displayAnswerSubmitButton =
    Button.button
        [ Button.success
        , Button.onClick SubmitAnswer
        , Button.attrs [ class "room-answer-button" ]
        ]
        [ text "submit" ]


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (map tagger keyCode)
