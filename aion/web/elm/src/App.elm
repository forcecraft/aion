module App exposing (..)

import General.Constants exposing (hostname)
import General.Models exposing (Flags, Model, initialModel)
import Msgs exposing (Msg)
import Navigation exposing (Location, modifyUrl)
import Phoenix.Socket
import Room.Api exposing (fetchRooms)
import Routing
import Update exposing (update)
import User.Api exposing (fetchCurrentUser)
import View exposing (view)


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        currentRoute =
            Routing.parseLocation location
    in
        ( initialModel flags currentRoute, Cmd.batch [ setHomeUrl, fetchRooms, fetchCurrentUser ] )


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


setHomeUrl : Cmd Msg
setHomeUrl =
    modifyUrl hostname
