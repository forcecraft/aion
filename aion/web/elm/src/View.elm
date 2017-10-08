module View exposing (..)

import Bootstrap.Navbar as Navbar
import General.Models exposing (Model, Route(LoginRoute, NotFoundRoute, PanelRoute, RoomListRoute, RoomRoute, UserRoute))
import General.View exposing (homeView, notFoundView, roomListView)
import Html exposing (..)
import Html.Attributes exposing (class, href, src)
import Msgs exposing (Msg(..))
import Navigation exposing (Location)
import Panel.View exposing (panelView)
import Room.View exposing (roomView)
import Routing exposing (panelPath, roomsPath, userPath)
import Urls exposing (host)
import User.View exposing (userView)


view : Model -> Html Msg
view model =
    div []
        [ page model ]


layout : Html Msg -> Location -> Navbar.State -> Html Msg
layout content location navbarState =
    div
        [ class "layout" ]
        [ navbar location navbarState
        , content
        ]


navbar : Location -> Navbar.State -> Html Msg
navbar location navbarState =
    Navbar.config NavbarMsg
        |> Navbar.withAnimation
        |> Navbar.success
        |> Navbar.container
        |> Navbar.brand
            [ href "#" ]
            [ img
                [ src ((host location) ++ "svg/hemp.svg")
                , class "header-aion-logo"
                ]
                []
            , text "Aion"
            ]
        |> Navbar.items
            [ Navbar.itemLink [ href roomsPath ] [ text "Rooms" ]
            , Navbar.itemLink [ href panelPath ] [ text "Workspace" ]
            , Navbar.itemLink [ href userPath ] [ text "Profile" ]
            ]
        |> Navbar.view navbarState


page : Model -> Html Msg
page model =
    let
        content =
            case model.route of
                LoginRoute ->
                    homeView model

                RoomListRoute ->
                    roomListView model

                RoomRoute id ->
                    roomView model id

                PanelRoute ->
                    panelView model

                UserRoute ->
                    userView model

                NotFoundRoute ->
                    notFoundView
    in
        layout content model.location model.navbarState
