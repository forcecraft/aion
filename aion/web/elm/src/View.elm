module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

import Msgs exposing (Msg(..))
import Models exposing (Model, Room)
import String exposing (concat)
import Routing exposing (roomsPath)


view: Model -> Html Msg
view model =
  div []
    [ page model ]


page: Model -> Html Msg
page model =
  case model.route of
    Models.LoginRoute ->
      loginView model

    Models.RoomsRoute ->
      roomsView model

    Models.NotFoundRoute ->
      notFoundView


-- LOGIN VIEW
loginView: Model -> Html Msg
loginView model =
  div []
    [ p [] [text "Welcome to Aion!"]
    , input [ type_ "text", placeholder "Username", onInput UpdateUsername] []
    , p [] [text (concat ["Hello ", model.username, ""])]
    , navigationButton
    ]


navigationButton: Html Msg
navigationButton =
  let
    path = roomsPath
  in
    a
      [ href path ]
      [ i [] []
      , text "Rooms"]


-- ROOMS VIEW
roomsView: Model -> Html Msg
roomsView model =
  div []
    [ div [ class "roomsNames" ] [ text "Rooms:" ]
    , listRooms model.rooms
    ]


listRooms: List Room -> Html Msg
listRooms rooms =
  ul []
    (List.map (\room -> li [] [ text room ]) rooms)


-- NOT FOUND VIEW
notFoundView: Html Msg
notFoundView =
  div []
    [ text "Not found"
    ]
