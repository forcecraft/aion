module Room.View exposing (..)

import General.Models exposing (Model)
import Html exposing (Attribute, Html, a, button, div, form, input, li, text, ul)
import Html.Attributes exposing (href, id, type_, value)
import Html.Events exposing (keyCode, on, onClick, onInput)
import Room.Utils exposing (getRoomList, getRoomNameById)
import Msgs exposing (Msg(KeyDown, SetAnswer, SubmitAnswer))
import Html exposing (Html, a, div, img, li, p, text, ul)
import Html.Attributes exposing (href, src)
import Msgs exposing (Msg)
import RemoteData exposing (WebData)
import Room.Models exposing (RoomId, RoomsData, UserInRoomRecord, answerInputFieldId)
import Json.Decode exposing (map)


roomListView : Model -> Html Msg
roomListView model =
    div []
        [ div [] [ text "Rooms:" ]
        , listRooms model.rooms
        ]


roomView : Model -> RoomId -> Html Msg
roomView model roomId =
    let
        roomName =
            getRoomNameById model roomId
    in
        div []
            [ text roomName
            , displayScores model
            , p [] [ text model.questionInChannel.content ]
            , displayQuestionImage model
            , displayAnswerInput model roomId
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


displayAnswerInput : Model -> RoomId -> Html Msg
displayAnswerInput model roomId =
    form []
        [ input [ id answerInputFieldId, onInput SetAnswer, onKeyDown KeyDown ] []
        , input [ type_ "button", value "submit", onClick (SubmitAnswer roomId) ] []
        ]


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (map tagger keyCode)


listRooms : WebData RoomsData -> Html Msg
listRooms response =
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success roomsData ->
            ul []
                (List.map (\room -> li [] [ a [ href ("#rooms/" ++ (toString room.id)) ] [ text room.name ] ]) roomsData.data)

        RemoteData.Failure error ->
            text (toString error)
