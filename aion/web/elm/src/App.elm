module App exposing (..)

import Html exposing (..)
import Msgs exposing (Msg)
import Models.Models exposing (Model, initialModel, Flags)
import Update exposing (update)
import View exposing (view)
import Navigation exposing (Location)
import Commands exposing (fetchRooms)
import Routing
import Phoenix.Socket


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        currentRoute =
            Routing.parseLocation location
    in
        ( initialModel flags currentRoute, fetchRooms )


subscriptions : Model -> Sub Msg
subscriptions model =
    Phoenix.Socket.listen model.socket Msgs.PhoenixMsg


main : Program Flags Model Msg
main =
    Navigation.programWithFlags Msgs.OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
