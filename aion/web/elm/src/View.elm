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
import User.View exposing (userView)


view : Model -> Html Msg
view model =
    div []
        [ page model ]


layout : Html Msg -> Model -> Html Msg
layout content model =
    div
        [ style
            [ ( "font-family", "'Roboto', sans-serif" )
            , ( "background-color", "#e6ffec" )
            , ( "padding-bottom", "60px" )
            ]
        ]
        [ navbar model
        , content
        ]


navbar : Model -> Html Msg
navbar model =
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
            [ Navbar.itemLink [ href "#/rooms" ] [ text "Rooms" ]
            , Navbar.itemLink [ href "#/panel" ] [ text "Panel" ]
            , Navbar.itemLink [ href "#/profile" ] [ text "Profile" ]
            ]
        |> Navbar.view model.navbarState


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
        layout content model
