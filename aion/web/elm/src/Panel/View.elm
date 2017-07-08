module Panel.View exposing (..)

import General.Models exposing (Model)
import Html exposing (..)
import Msgs exposing (Msg(..))


panelView : Model -> Html Msg
panelView model =
    div [] []
