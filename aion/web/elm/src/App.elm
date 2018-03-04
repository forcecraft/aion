module App exposing (..)

import Bootstrap.Navbar as Navbar
import General.Models exposing (Flags, Model, initialModel)
import Msgs exposing (Msg(MkGeneralMsg, MkPanelMsg, MkRoomMsg, MkUserMsg, NavbarMsg))
import Multiselect
import Navigation exposing (Location, modifyUrl)
import Panel.Api exposing (fetchCategories)
import Panel.Msgs exposing (PanelMsg(MultiselectMsg))
import Phoenix.Socket
import Room.Api exposing (fetchRooms)
import Room.Msgs exposing (RoomMsg(PhoenixMsg))
import Room.Subscriptions
import Routing
import Update exposing (update)
import UpdateHelpers exposing (setHomeUrl)
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
            , Cmd.map MkGeneralMsg (fetchRooms location flags.token)
            , Cmd.map MkPanelMsg (fetchCategories location flags.token)
            , Cmd.map MkUserMsg (fetchCurrentUser location flags.token)
            ]
        )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Phoenix.Socket.listen model.socket PhoenixMsg |> Sub.map MkRoomMsg
        , Navbar.subscriptions model.navbarState NavbarMsg
        , Multiselect.subscriptions model.panelData.categoryMultiSelect |> Sub.map MultiselectMsg |> Sub.map MkPanelMsg
        , Room.Subscriptions.subscriptions model |> Sub.map MkRoomMsg
        ]


main : Program Flags Model Msg
main =
    Navigation.programWithFlags Msgs.OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
