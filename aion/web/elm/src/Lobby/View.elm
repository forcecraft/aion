module Lobby.View exposing (..)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Lobby.Utils exposing (displayWebData, sliceList)
import Html exposing (Html, a, br, button, div, h2, h3, h4, hr, i, img, li, p, span, text, ul)
import Html.Attributes exposing (class, href, src, style)
import Lobby.Models exposing (LobbyData, Room)
import Lobby.Msgs exposing (LobbyMsg)


asGridContainer : List (Html msg) -> Html msg
asGridContainer data =
    Grid.container [] data


lobbyView : LobbyData -> Html LobbyMsg
lobbyView model =
    div []
        [ h4 [ class "room-list-label" ] [ text "Recommended" ]
        , displayRooms model Recommended
        , hr [ class "room-content-separator" ] []
        , h4 [ class "room-list-label" ] [ text "All rooms" ]
        , displayRooms model All
        ]


type FilterType
    = Recommended
    | All


displayRooms : LobbyData -> FilterType -> Html LobbyMsg
displayRooms rooms filterType =
    let
        fun =
            case filterType of
                Recommended ->
                    listRecommendedRooms

                All ->
                    listRooms
    in
        div [] [ fun rooms ]


listRooms : LobbyData -> Html LobbyMsg
listRooms rooms =
    rooms
        |> .data
        |> List.sortBy .name
        |> sliceList 6
        |> List.map listRoomsSlice
        |> asGridContainer


listRecommendedRooms : LobbyData -> Html LobbyMsg
listRecommendedRooms rooms =
    listRooms { rooms | data = List.take 6 rooms.data }


listRoomsSlice : List Room -> Html LobbyMsg
listRoomsSlice rooms =
    Grid.row [] (List.map listSingleRoom rooms)


listSingleRoom : Room -> Grid.Column LobbyMsg
listSingleRoom room =
    Grid.col [ Col.lg2, Col.md4 ]
        [ div [ class "tile" ] [ displayRoomLabel room ] ]


displayRoomLabel : Room -> Html LobbyMsg
displayRoomLabel room =
    let
        url =
            "#rooms/" ++ (toString room.id)

        roomName =
            room.name

        playerCount =
            case room.player_count of
                0 ->
                    "empty"

                1 ->
                    "1 player"

                _ ->
                    toString (room.player_count) ++ " players"
    in
        a [ href url ]
            [ p [ class "tile-room-name" ] [ text roomName ]
            , p [ class "tile-player-count" ] [ text playerCount ]
            ]
