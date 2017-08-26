module View exposing (..)

import Bootstrap.Navbar as Navbar
import General.Constants exposing (hostname)
import General.Models exposing (Model, Route(LoginRoute, NotFoundRoute, PanelRoute, RoomListRoute, RoomRoute, UserRoute))
import General.View exposing (homeView, notFoundView, roomListView)
import Html exposing (..)
import Html.Attributes exposing (class, href, src, style)
import Msgs exposing (Msg(..))
import Panel.View exposing (panelView)
import Room.View exposing (roomView)
import Routing exposing (panelPath, roomsPath, userPath)
import User.View exposing (userView)


view : Model -> Html Msg
view model =
    div []
        [ page model ]


layout : Html Msg -> Navbar.State -> Html Msg
layout content navbarState =
    div
        [ style
            [ ( "font-family", "'Roboto', sans-serif" )
            , ( "background-color", "#e6ffec" )
            , ( "padding-bottom", "60px" )
            ]
        ]
        [ navbar navbarState
        , content
        ]


navbar : Navbar.State -> Html Msg
navbar navbarState =
    Navbar.config NavbarMsg
        |> Navbar.withAnimation
        |> Navbar.success
        |> Navbar.container
        |> Navbar.brand
            [ href "#" ]
            [ img
                [ src (hostname ++ "svg/hemp.svg")
                , class "header-aion-logo"
                ]
                []
            , text "Aion"
            ]
        |> Navbar.items
            [ Navbar.itemLink [ href roomsPath ] [ text "Rooms" ]
            , Navbar.itemLink [ href panelPath ] [ text "Panel" ]
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
        layout content model.navbarState
