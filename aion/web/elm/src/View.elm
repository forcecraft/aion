module View exposing (..)

import General.Models exposing (Model, Route(LoginRoute, NotFoundRoute, PanelRoute, RoomListRoute, RoomRoute, UserRoute))
import General.View exposing (homeView, notFoundView, roomListView)
import Html exposing (..)
import Msgs exposing (Msg(..))
import Panel.View exposing (panelView)
import Room.View exposing (roomView)
import User.View exposing (userView)


view : Model -> Html Msg
view model =
    div []
        [ page model ]


page : Model -> Html Msg
page model =
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
