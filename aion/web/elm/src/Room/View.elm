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
import Html.Attributes exposing (for, href, id, src, style, type_, value)
import Html.Events exposing (keyCode, on, onClick, onInput, onWithOptions)
import Json.Decode exposing (map)
import Msgs exposing (Msg(..))
import Html exposing (Html, a, div, img, li, p, text, ul)
import Room.Constants exposing (answerInputFieldId, defaultImagePath, imagesPath)
import Room.Models exposing (Answer, ImageName, RoomId, RoomsData, UserGameData, UserInRoomRecord)
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

        imageName =
            model.questionInChannel.image_name
    in
        Grid.container [ style [ ( "padding", "10px 50px" ) ] ]
            [ Grid.row []
                [ Grid.col []
                    [ h4 [] [ text roomName ]
                    , displayQuestion model.questionInChannel.content
                    , displayQuestionImage imageName
                    , displayAnswerInput currentAnswer
                    , Toasty.view toastsConfig Toasty.Defaults.view ToastyMsg model.toasties
                    ]
                , Grid.col []
                    [ h4 [] [ text "Scoreboard:" ]
                    , displayScores model
                    ]
                ]
            ]


displayScores : Model -> Html Msg
displayScores model =
    div
        [ style
            [ ( "margin-top", "20px" )
            , ( "position", "relative" )
            , ( "z-index", "0" )
            ]
        ]
        [ ListGroup.ul (List.map displaySingleScore model.usersInChannel) ]


displaySingleScore : UserInRoomRecord -> ListGroup.Item msg
displaySingleScore userRecord =
    ListGroup.li [] [ text (userRecord.name ++ ": " ++ (toString userRecord.score)) ]


displayQuestion : String -> Html Msg
displayQuestion question =
    Card.config [ Card.attrs [ style [ ( "margin-top", "20px" ), ( "margin-bottom", "20px" ) ] ] ]
        |> Card.block []
            [ Card.text [] [ text question ] ]
        |> Card.view


displayQuestionImage : ImageName -> Html Msg
displayQuestionImage imageName =
    let
        imageStyles =
            [ ( "max-width", "100%" )
            , ( "height", "300px" )
            ]
    in
        case imageName of
            "" ->
                img [ style imageStyles, src defaultImagePath ] []

            imageName ->
                img [ style imageStyles, src (imagesPath ++ imageName) ] []


displayAnswerInput : Answer -> Html Msg
displayAnswerInput currentAnswer =
    Form.form [ style [ ( "padding-top", "20px" ) ] ]
        [ Form.group []
            [ Form.label [ for "answer" ] [ Badge.badgeSuccess [] [ text "Put your answer below:" ] ]
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
        , Button.attrs [ style [ ( "margin-top", "20px" ) ] ]
        ]
        [ text "submit" ]


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (map tagger keyCode)
