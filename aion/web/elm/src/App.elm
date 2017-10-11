module App exposing (..)

import Bootstrap.Navbar as Navbar
import General.Models exposing (Flags, Model, initialModel)
import Msgs exposing (Msg(NavbarMsg))
import Multiselect
import Navigation exposing (Location, modifyUrl)
import Panel.Api exposing (fetchCategories)
import Phoenix.Socket
import Room.Api exposing (fetchRooms)
import Routing
import Update exposing (update)
import Urls exposing (host)
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
            initialModel flags currentRoute location
    in
        ( { getInitialModel | navbarState = navbarState }
        , Cmd.batch
            [ setHomeUrl location
            , navbarCmd
            , fetchRooms location flags.token
            , fetchCategories location flags.token
            , fetchCurrentUser location flags.token
            ]
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


setHomeUrl : Location -> Cmd Msg
setHomeUrl location =
    modifyUrl (host location)
