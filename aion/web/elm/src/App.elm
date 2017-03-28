module App exposing (..)

import Html exposing (..)
import Msgs exposing (Msg)
import Models exposing (..)
import Update exposing (update)
import View exposing (..)
import Navigation exposing (Location)
import Routing


init : Location -> ( Model, Cmd Msg )
init location =
  let
    currentRoute =
      Routing.parseLocation location
  in
    ( initialModel currentRoute, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


--MAIN
main : Program Never Model Msg
main =
    Navigation.program Msgs.OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
