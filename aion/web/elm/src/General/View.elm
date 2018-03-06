module General.View exposing (..)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import General.Models exposing (Model)
import General.Utils exposing (displayWebData)
import Html exposing (Html, a, br, button, div, h2, h3, h4, hr, i, img, li, p, span, text, ul)
import Html.Attributes exposing (class, href, src, style)
import Lobby.Models exposing (LobbyData, Room)
import Lobby.Msgs exposing (LobbyMsg)
import Msgs exposing (Msg)
import RemoteData exposing (WebData)


asGridContainer data =
    Grid.container [] data


roomListView : Model -> Html LobbyMsg
roomListView model =
    div []
        [ h4 [ class "room-list-label" ] [ text "Recommended" ]
        , displayRooms model.rooms Recommended
        , hr [ class "room-content-separator" ] []
        , h4 [ class "room-list-label" ] [ text "All rooms" ]
        , displayRooms model.rooms All
        ]


type FilterType
    = Recommended
    | All


displayRooms : WebData LobbyData -> FilterType -> Html LobbyMsg
displayRooms rooms filterType =
    let
        fun =
            case filterType of
                Recommended ->
                    listRecommendedRooms

                All ->
                    listRooms
    in
        div [] [ displayWebData rooms fun ]


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
