module View exposing (..)

import Auth.View exposing (authView)
import Bootstrap.Navbar as Navbar
import General.Constants exposing (footerContent, roomsPath, userPath)
import General.Models exposing (Model, Route(AuthRoute, NotFoundRoute, RoomListRoute, RoomRoute, UserRoute))
import General.View exposing (notFoundView, roomListView)
import Html exposing (..)
import Html.Attributes exposing (class, href, src)
import Msgs exposing (Msg(..))
import Navigation exposing (Location)
import Room.View exposing (roomView)
import Urls exposing (host)
import User.View exposing (userView)


view : Model -> Html Msg
view model =
    div []
        [ page model ]


layout : Html Msg -> Route -> Location -> Navbar.State -> Html Msg
layout content route location navbarState =
    div []
        [ navbar route location navbarState
        , div
            [ class "layout" ]
            [ content ]
        , customFooter footerContent
        ]


customFooter : List String -> Html Msg
customFooter footerContent =
    footer []
        (List.map
            (\paragraph -> p [] [ text paragraph ])
            footerContent
        )


navbar : Route -> Location -> Navbar.State -> Html Msg
navbar route location navbarState =
    let
        logoUrl =
            (host location) ++ "images/aion_logo.png"

        baseNavbar =
            Navbar.config NavbarMsg
                |> Navbar.withAnimation
                |> Navbar.success
                |> Navbar.container
                |> Navbar.brand
                    [ href "#" ]
                    [ img [ src logoUrl, class "header-aion-logo" ] []
                    , text "Aion"
                    ]
    in
        case route of
            AuthRoute ->
                baseNavbar
                    |> Navbar.view navbarState

            _ ->
                baseNavbar
                    |> Navbar.items
                        [ Navbar.itemLink [ href roomsPath ] [ text "Rooms" ]
                        , Navbar.itemLink [ href userPath ] [ text "Profile" ]
                        ]
                    |> Navbar.view navbarState


page : Model -> Html Msg
page model =
    let
        route =
            redirectIfNotAuthenticated model.authData.token model.route

        content =
            case route of
                AuthRoute ->
                    authView model

                RoomListRoute ->
                    roomListView model

                RoomRoute id ->
                    roomView model id

                UserRoute ->
                    userView model

                NotFoundRoute ->
                    notFoundView

        location =
            model.location

        navbarState =
            model.navbarState
    in
        layout content route location navbarState


redirectIfNotAuthenticated : Maybe String -> Route -> Route
redirectIfNotAuthenticated token currentRoute =
    case token of
        Nothing ->
            AuthRoute

        Just _ ->
            currentRoute
