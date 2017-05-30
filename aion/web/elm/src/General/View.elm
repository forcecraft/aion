module General.View exposing (..)

import Html exposing (Html, div, text)
import Msgs exposing (Msg)


notFoundView : Html Msg
notFoundView =
    div []
        [ text "Not found"
        ]
