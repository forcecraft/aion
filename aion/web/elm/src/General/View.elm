module General.View exposing (..)

import General.Models exposing (Model)
import Html exposing (Html, a, div, i, li, p, text, ul)
import Html.Attributes exposing (href)
import Msgs exposing (Msg)
import Routing exposing (panelPath, roomsPath)
import RemoteData exposing (WebData)
import Room.Models exposing (RoomsData)
import Routing exposing (roomsPath)


notFoundView : Html Msg
notFoundView =
    div []
        [ text "Not found"
        ]


homeView : Model -> Html Msg
homeView model =
    div []
        [ p [] [ text "Welcome to Aion!" ]
        , ul []
            [ li [] [ a [ href roomsPath ] [ text "Rooms" ] ]
            , li [] [ a [ href panelPath ] [ text "Panel" ] ]
            ]
        ]


roomListButton : Html Msg
roomListButton =
    let
        path =
            roomsPath
    in
        a
            [ href path ]
            [ i [] []
            , text "Rooms"
            ]


roomListView : Model -> Html Msg
roomListView model =
    div []
        [ div [] [ text "Rooms:" ]
        , listRooms model.rooms
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
