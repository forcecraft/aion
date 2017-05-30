module View exposing (..)

import General.Models exposing (Model, Route(LoginRoute, NotFoundRoute, RoomListRoute, RoomRoute, RoomsRoute))
import General.View exposing (homeView, notFoundView)
import Html exposing (..)
import Html.Attributes exposing (..)
import Msgs exposing (Msg(..))
import Routing exposing (roomsPath)
import RemoteData exposing (WebData)
import Room.Models exposing (RoomId, RoomsData)
import Room.View exposing (roomListView, roomView)


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
