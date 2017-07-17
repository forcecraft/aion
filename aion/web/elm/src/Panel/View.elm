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
            [ p [] [ text "Enter question content below:" ]
            , input [ placeholder "How much is 2+2?", onInput SetNewQuestionContent ] []
            , p [] [ text "Enter answer below, separate all posibilities with comma:" ]
            , input [ placeholder "4", onInput SetNewAnswerContent ] []
            , p [] [ text "Select the category to which to add the question:" ]
            , Select.from (listRooms model.rooms) SetNewAnswerCategory
            , input [ type_ "button", value "submit", onClick CreateNewQuestionWithAnswers ] []
            ]
        ]


listRooms : WebData RoomsData -> List String
listRooms result =
    case result of
        RemoteData.Success roomsData ->
            List.map (\room -> room.name) roomsData.data

        _ ->
            []
