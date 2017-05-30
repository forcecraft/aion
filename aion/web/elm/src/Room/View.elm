module Room.View exposing (..)

import General.Models exposing (Model)
import Html exposing (Html, div, text, ul)
import Msgs exposing (Msg)
import RemoteData exposing (WebData)
import Room.Models exposing (RoomId, RoomsData)


roomListView : Model -> Html Msg
roomListView model =
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
                (List.map (\userRecord -> li [] [ text (userRecord.name ++ ": " ++ (toString userRecord.score)) ]) model.usersInChannel)
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
