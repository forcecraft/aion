module App exposing (..)

import Html exposing (..)
import Msgs exposing (Msg)
import Models.Models exposing (Model, initialModel)
import Update exposing (update)
import View exposing (view)
import Navigation exposing (Location)
import Commands exposing (fetchRooms)
import Routing
import Phoenix.Socket


init : Location -> ( Model, Cmd Msg )
init location =
  let
    currentRoute = Routing.parseLocation location
  in
    ( initialModel currentRoute, fetchRooms )


subscriptions : Model -> Sub Msg
subscriptions model =
 Phoenix.Socket.listen model.socket Msgs.PhoenixMsg

--MAIN
main : Program Never Model Msg
main =
    Navigation.program Msgs.OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
