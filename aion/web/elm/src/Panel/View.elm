module Panel.View exposing (..)

import General.Models exposing (Model)
import Html exposing (..)
import Html.Attributes exposing (placeholder, type_, value)
import Html.Events exposing (onClick, onInput)
import Msgs exposing (Msg(..))


panelView : Model -> Html Msg
panelView model =
    form []
        [ input [ placeholder "Enter question", onInput SetNewQuestionContent ] []
        , br [] []
        , input [ placeholder "Enter answers", onInput SetNewAnswerContent ] []
        , br [] []
        , input [ type_ "button", value "submit", onClick CreateNewQuestionWithAnswers ] []
        , br [] []
        ]
