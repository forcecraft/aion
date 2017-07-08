module Panel.View exposing (..)

import General.Models exposing (Model)
import Html exposing (..)
import Html.Attributes exposing (placeholder, type_, value)
import Html.Events exposing (onClick, onInput)
import Msgs exposing (Msg(..))
import RemoteData exposing (WebData)
import Room.Models exposing (RoomsData)
import Select


panelView : Model -> Html Msg
panelView model =
    div []
        [ h3 [] [ text "Create new question for certain category:" ]
        , form []
            [ input [ placeholder "Enter question", onInput SetNewQuestionContent ] []
            , br [] []
            , input [ placeholder "Enter answers", onInput SetNewAnswerContent ] []
            , br [] []
            , Select.from (listRooms model.rooms) SetNewAnswerCategory
            , br [] []
            , input [ type_ "button", value "submit", onClick CreateNewQuestionWithAnswers ] []
            , br [] []
            ]
        ]


listRooms : WebData RoomsData -> List String
listRooms result =
    case result of
        RemoteData.Success roomsData ->
            List.map (\room -> room.name) roomsData.data

        _ ->
            []
