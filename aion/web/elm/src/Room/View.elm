module Room.View exposing (..)

import Bootstrap.Badge as Badge
import Bootstrap.Button as Button
import Bootstrap.Card as Card
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Grid as Grid
import Bootstrap.ListGroup as ListGroup
import General.Models exposing (Model)
import General.Notifications exposing (toastsConfig)
import Html exposing (Attribute, Html, a, button, div, form, h4, input, li, text, ul)
import Html.Attributes exposing (class, for, href, id, src, value)
import Html.Events exposing (keyCode, on, onClick, onInput, onWithOptions)
import Json.Decode exposing (map)
import Msgs exposing (Msg(..))
import Html exposing (Html, a, div, img, li, p, text, ul)
import Navigation exposing (Location)
import Room.Constants exposing (answerInputFieldId, defaultImagePath, imagesPath)
import Room.Models exposing (Answer, ImageName, RoomId, RoomState(QuestionBreak, QuestionDisplayed, Uninitialized), RoomsData, UserGameData, UserInRoomRecord)
import Room.Utils exposing (getRoomList, getRoomNameById)
import Toasty
import Toasty.Defaults


roomView : Model -> RoomId -> Html Msg
roomView model roomId =
    let
        roomName =
            getRoomNameById model roomId

        currentAnswer =
            model.userGameData.currentAnswer
    in
        Grid.container [ class "room-container" ]
            [ Grid.row []
                [ Grid.col []
                    [ h4 [] [ text roomName ]
                    , fillQuestionArea model
                    , displayAnswerInput currentAnswer
                    , Toasty.view toastsConfig Toasty.Defaults.view ToastyMsg model.toasties
                    ]
                , Grid.col []
                    [ h4 [] [ text "Scoreboard:" ]
                    , displayScores model
                    ]
                ]
            ]


fillQuestionArea : Model -> Html Msg
fillQuestionArea model =
    let
        imageName =
            model.questionInChannel.image_name

        roomState =
            Debug.log "the state is" model.roomState
    in
        case model.roomState of
            QuestionDisplayed ->
                div []
                    [ displayQuestion model.questionInChannel.content
                    , displayQuestionImage model.location imageName
                    ]

            QuestionBreak ->
                div [] [ text "test" ]

            Uninitialized ->
                div [] [ text "UNITITIALIZED" ]


displayScores : Model -> Html Msg
displayScores model =
    div
        [ class "room-scoreboard" ]
        [ ListGroup.ul (List.map displaySingleScore model.usersInChannel) ]


displaySingleScore : UserInRoomRecord -> ListGroup.Item msg
displaySingleScore userRecord =
    ListGroup.li [] [ text (userRecord.name ++ ": " ++ (toString userRecord.score)) ]


displayQuestion : String -> Html Msg
displayQuestion question =
    Card.config [ Card.attrs [ class "room-question" ] ]
        |> Card.block [] [ Card.text [] [ text question ] ]
        |> Card.view


displayQuestionImage : Location -> ImageName -> Html Msg
displayQuestionImage location imageName =
    case imageName of
        "" ->
            img [ class "room-image", src (defaultImagePath location) ] []

        imageName ->
            img [ class "room-image", src ((imagesPath location) ++ imageName) ] []


displayAnswerInput : Answer -> Html Msg
displayAnswerInput currentAnswer =
    Form.form [ class "room-answer-input" ]
        [ Form.group []
            [ Form.label [ for "answer" ] [ Badge.badgeSuccess [] [ text "Insert your answer below:" ] ]
            , displayAnswerInputField currentAnswer
            , displayAnswerSubmitButton
            ]
        ]


displayAnswerInputField : Answer -> Html Msg
displayAnswerInputField currentAnswer =
    Input.text
        [ Input.id answerInputFieldId
        , Input.onInput SetAnswer
        , Input.value currentAnswer
        ]


displayAnswerSubmitButton : Html Msg
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
