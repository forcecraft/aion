module View exposing (..)

import Auth.View exposing (authView)
import Bootstrap.Navbar as Navbar
import Bootstrap.Button as Button
import General.Constants exposing (roomsPath, userPath, rankingsPath)
import General.Models exposing (Model, Route(AuthRoute, NotFoundRoute, RoomListRoute, RoomRoute, UserRoute, RankingRoute))
import General.View exposing (notFoundView, roomListView)
import Html exposing (..)
import Html.Attributes exposing (class, href, src)
import Msgs exposing (Msg(..))
import Navigation exposing (Location)
import Room.View exposing (roomView)
import Ranking.View exposing (rankingView)
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
            , Navbar.itemLink [ href userPath ] [ text "Profile" ]
            , Navbar.itemLink [ href rankingsPath ] [ text "Rankings" ]
            ]
        |> Navbar.customItems
            [ Navbar.customItem
                (Button.button
                    [ Button.roleLink
                    , Button.onClick Logout
                    ]
                    [ text "Logout" ]
                )
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
                    \content _ _ -> content

                _ ->
                    layout

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

                RankingRoute ->
                    rankingView model

                NotFoundRoute ->
                    notFoundView
    in
        includeNavbar content model.location model.navbarState


redirectIfNotAuthenticated : Maybe String -> Route -> Route
redirectIfNotAuthenticated token currentRoute =
    case token of
        Nothing ->
            AuthRoute

        Just _ ->
            currentRoute
