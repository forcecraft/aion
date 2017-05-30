module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Msgs exposing (Msg(..))
import Models.Models exposing (Model)
import Models.Room exposing (Room, RoomId, RoomsData)
import String exposing (concat)
import Routing exposing (roomsPath)
import RemoteData exposing (WebData)


view : Model -> Html Msg
view model =
    div []
        [ page model ]


page : Model -> Html Msg
page model =
    case model.route of
        Models.Models.LoginRoute ->
            loginView model

        Models.Models.RoomsRoute ->
            roomsView model

        Models.Models.RoomRoute id ->
            roomView model id

        Models.Models.NotFoundRoute ->
            notFoundView



-- LOGIN VIEW


loginView : Model -> Html Msg
loginView model =
    div []
        [ p [] [ text "Welcome to Aion!" ]
        , navigationButton
        ]


navigationButton : Html Msg
navigationButton =
    let
        path =
            roomsPath
    in
        a
            [ href path ]
            [ i [] []
            , text "Rooms"
            ]



-- ROOMS VIEW


roomsView : Model -> Html Msg
roomsView model =
    div []
        [ div [] [ text "Rooms:" ]
        , listRooms model.rooms
        ]


roomView : Model -> RoomId -> Html Msg
roomView model roomId =
    let
        roomList =
            case model.rooms of
                RemoteData.Success roomsData ->
                    roomsData.data

                _ ->
                    []

        room =
            List.filter (\room -> room.id == roomId) roomList
                |> List.head

        roomName =
            case room of
                Just room ->
                    "Room# " ++ room.name

                _ ->
                    "Room Not Found"
    in
        div []
            [ text roomName
            , ul []
                (List.map (\userRecord -> li [] [ text (userRecord.name ++ " :" ++ (toString userRecord.score)) ]) model.usersInChannel)
            ]


listRooms : WebData RoomsData -> Html Msg
listRooms response =
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success roomsData ->
            ul []
                (List.map (\room -> li [] [ a [ href ("#rooms/" ++ (toString room.id)) ] [ text room.name ] ]) roomsData.data)

        RemoteData.Failure error ->
            text (toString error)



-- NOT FOUND VIEW


notFoundView : Html Msg
notFoundView =
    div []
        [ text "Not found"
        ]
