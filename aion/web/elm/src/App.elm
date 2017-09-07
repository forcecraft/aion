module App exposing (..)

import Bootstrap.Navbar as Navbar
import General.Constants exposing (hostname)
import General.Models exposing (Flags, Model, initialModel)
import Msgs exposing (Msg(NavbarMsg))
import Multiselect
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

        ( navbarState, navbarCmd ) =
            Navbar.initialState NavbarMsg

        getInitialModel =
            initialModel flags currentRoute
    in
        ( { getInitialModel | navbarState = navbarState }
        , Cmd.batch [ setHomeUrl, fetchRooms, fetchCurrentUser, navbarCmd ]
        )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Phoenix.Socket.listen model.socket Msgs.PhoenixMsg
        , Navbar.subscriptions model.navbarState NavbarMsg
        , Sub.map Msgs.MultiselectMsg <| Multiselect.subscriptions model.panelData.categoryMultiSelect
        ]


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
