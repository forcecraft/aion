module View exposing (..)

import General.Models exposing (Model, Route(LoginRoute, NotFoundRoute, PanelRoute, RoomListRoute, RoomRoute))
import General.View exposing (homeView, notFoundView, roomListView)
import Html exposing (..)
import Html.Attributes exposing (style, class)
import Msgs exposing (Msg(..))
import Panel.View exposing (panelView)
import Room.View exposing (roomView)


view : Model -> Html Msg
view model =
    div []
        [ page model ]


layout : Html msg -> Html msg
layout content =
    div [ style [ ( "font-family", "'Roboto', sans-serif" ) ] ]
        [ content ]


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

                NotFoundRoute ->
                    notFoundView
    in
        layout content
