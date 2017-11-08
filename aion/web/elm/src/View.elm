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
    case route of
        _ ->
            Navbar.config NavbarMsg
                |> Navbar.withAnimation
                |> Navbar.success
                |> Navbar.container
                |> Navbar.brand
                    [ href "#" ]
                    [ img
                        [ src ((host location) ++ "images/aion_logo.png")
                        , class "header-aion-logo"
                        ]
                        []
                    , text "Aion"
                    ]
                |> Navbar.view navbarState


page : Model -> Html Msg
page model =
    let
        currentRoute =
            redirectIfNotAuthenticated model.authData.token model.route

        content =
            case currentRoute of
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
    in
        layout content model.route model.location model.navbarState


redirectIfNotAuthenticated : Maybe String -> Route -> Route
redirectIfNotAuthenticated token currentRoute =
    case token of
        Nothing ->
            AuthRoute

        Just _ ->
            currentRoute
