module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

import Msgs exposing (Msg(..))
import Models exposing (Model)
import String exposing (concat)

view: Model -> Html Msg
view model =
  div []
    [ p [] [text "Welcome to Aion!"]
    , input [ type_ "text", placeholder "Username", onInput Username] []
    , p [] [text (concat ["Hello ", model.username, ""])]
    ]
