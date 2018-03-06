module View exposing (..)

import Auth.View exposing (authView)
import Bootstrap.Navbar as Navbar
import General.Constants exposing (footerContent, roomsPath, createRoomPath, userPath, rankingsPath)
import General.Models exposing (Model, Route(AuthRoute, CreateRoomRoute, NotFoundRoute, RankingRoute, RoomListRoute, RoomRoute, UserRoute))
import General.View exposing (roomListView)
import Html exposing (..)
import Html.Attributes exposing (class, href, src)
import Msgs exposing (Msg(..))
import Navigation exposing (Location)
import Panel.View exposing (panelView)
import Room.View exposing (roomView)
import Ranking.View exposing (rankingView)
import Urls exposing (createRoomUrl, host, lobbyUrl, rankingUrl, userUrl)
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
            (host location) ++ "logo/aion_logo.png"

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
                        [ Navbar.itemLink [ href lobbyUrl ] [ text "Rooms" ]
                        , Navbar.itemLink [ href createRoomUrl ] [ text "Create room" ]
                        , Navbar.itemLink [ href rankingUrl ] [ text "Rankings" ]
                        , Navbar.itemLink [ href userUrl ] [ text "Profile" ]
                        ]
                    |> Navbar.view navbarState


notFoundView : Html Msg
notFoundView =
    div []
        [ text "Not found"
        ]


page : Model -> Html Msg
page model =
    let
        route =
            redirectIfNotAuthenticated model.authData.token model.route

        content =
            case route of
                AuthRoute ->
                    authView model |> Html.map MkAuthMsg

                RoomListRoute ->
                    roomListView model |> Html.map MkGeneralMsg

                RoomRoute id ->
                    roomView model id |> Html.map MkRoomMsg

                CreateRoomRoute ->
                    panelView model |> Html.map MkPanelMsg

                UserRoute ->
                    userView model |> Html.map MkUserMsg

                RankingRoute ->
                    rankingView model |> Html.map MkRankingMsg

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
