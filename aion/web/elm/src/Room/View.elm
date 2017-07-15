module Room.View exposing (..)

import General.Models exposing (Model)
import Html exposing (Attribute, Html, a, button, div, form, input, li, text, ul)
import Html.Attributes exposing (href, id, type_, value)
import Html.Events exposing (keyCode, on, onClick, onInput, onWithOptions)
import Room.Utils exposing (getRoomList, getRoomNameById)
import Msgs exposing (Msg(KeyDown, NoOperation, SetAnswer, SubmitAnswer))
import Html exposing (Html, a, div, img, li, p, text, ul)
import Html.Attributes exposing (href, src)
import Msgs exposing (Msg)
import RemoteData exposing (WebData)
import Room.Models exposing (Answer, RoomId, RoomsData, UserGameData, UserInRoomRecord, answerInputFieldId)
import Json.Decode exposing (map)


roomView : Model -> RoomId -> Html Msg
roomView model roomId =
    let
        roomName =
            getRoomNameById model roomId

        currentAnswer =
            model.userGameData.currentAnswer
    in
        div []
            [ text roomName
            , displayScores model
            , p [] [ text model.questionInChannel.content ]
            , displayQuestionImage model
            , displayAnswerInput currentAnswer
            ]


displayScores : Model -> Html Msg
displayScores model =
    ul [] (List.map displaySingleScore model.usersInChannel)


displaySingleScore : UserInRoomRecord -> Html Msg
displaySingleScore userRecord =
    li [] [ text (userRecord.name ++ ": " ++ (toString userRecord.score)) ]


displayQuestionImage : Model -> Html Msg
displayQuestionImage model =
    case model.questionInChannel.image_name of
        "" ->
            text "No image"

        imageName ->
            img [ src ("http://localhost:4000/images/" ++ imageName) ] []


displayAnswerInput : Answer -> Html Msg
displayAnswerInput currentAnswer =
    form
        [ onWithOptions "submit" { preventDefault = True, stopPropagation = False } (Json.Decode.succeed (NoOperation)) ]
        [ displayAnswerInputField currentAnswer
        , displayAnswerSubmitButton
        ]


displayAnswerInputField : Answer -> Html Msg
displayAnswerInputField currentAnswer =
    input
        [ id answerInputFieldId
        , onInput SetAnswer
        , onKeyDown KeyDown
        , value currentAnswer
        ]
        []


displayAnswerSubmitButton : Html Msg
displayAnswerSubmitButton =
    input
        [ type_ "button"
        , value "submit"
        , onClick SubmitAnswer
        ]
        []


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (map tagger keyCode)
