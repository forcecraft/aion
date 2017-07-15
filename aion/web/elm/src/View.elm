module View exposing (..)

import General.Models exposing (Model, Route(LoginRoute, NotFoundRoute, RoomListRoute, RoomRoute))
import General.View exposing (homeView, notFoundView, roomListView)
import Html exposing (..)
import Msgs exposing (Msg(..))
import Room.View exposing (roomView)


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

        NotFoundRoute ->
            notFoundView
