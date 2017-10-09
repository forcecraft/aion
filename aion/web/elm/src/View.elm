module View exposing (..)

import Auth.Views exposing (authView)
import Bootstrap.Navbar as Navbar
import General.Constants exposing (hostname, panelPath, roomsPath, userPath)
import General.Models exposing (Model, Route(HomeRoute, AuthRoute, NotFoundRoute, PanelRoute, RoomListRoute, RoomRoute, UserRoute))
import General.View exposing (homeView, notFoundView, roomListView)
import Html exposing (..)
import Html.Attributes exposing (class, href, src)
import Msgs exposing (Msg(..))
import Panel.View exposing (panelView)
import Room.View exposing (roomView)
import User.View exposing (userView)


view : Model -> Html Msg
view model =
    div []
        [ page model ]


layout : Html Msg -> Navbar.State -> Html Msg
layout content navbarState =
    div
        [ class "layout" ]
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
        currentRoute =
            redirectIfNotAuthenticated model.authData.token model.route

        includeNavbar =
            case currentRoute of
                AuthRoute ->
                    \x y -> x

                _ ->
                    layout

        content =
            case currentRoute of
                AuthRoute ->
                    authView model.authData

                HomeRoute ->
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
        includeNavbar content model.navbarState


redirectIfNotAuthenticated : Maybe String -> Route -> Route
redirectIfNotAuthenticated token currentRoute =
    case token of
        Nothing ->
            AuthRoute

        Just _ ->
            currentRoute
