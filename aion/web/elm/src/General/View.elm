module General.View exposing (..)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import General.Models exposing (Model)
import General.Utils exposing (displayWebData, sliceList)
import Html exposing (Html, a, br, button, div, h2, h3, h4, hr, i, img, li, p, span, text, ul)
import Html.Attributes exposing (class, href, src, style)
import Msgs exposing (Msg)
import RemoteData exposing (WebData)
import Room.Models exposing (RoomsData, Room)


notFoundView : Html Msg
notFoundView =
    div []
        [ text "Not found"
        ]


asGridContainer : List (Html msg) -> Html msg
asGridContainer data =
    Grid.containerFluid [] data


roomListView : Model -> Html Msg
roomListView model =
    div []
        [ displaySpecialRooms model.rooms
        , hr [ class "room-content-separator" ] []
        , displayRooms model.rooms All
        ]


type FilterType
    = Recommended
    | All


displaySpecialRooms : WebData RoomsData -> Html Msg
displaySpecialRooms rooms =
    let
        fun =
            \rooms ->
                let
                    data =
                        rooms
                            |> .data
                            |> List.take 3
                in
                    Grid.container []
                        [ Grid.row [] (List.map displaySpecialRoom data) ]
    in
        div [] [ displayWebData rooms fun ]


displaySpecialRoom room =
    Grid.col [] [ div [ class "tile" ] [ displayRoomLabel room Recommended ] ]


displayRooms : WebData RoomsData -> FilterType -> Html Msg
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


listRooms : RoomsData -> Html Msg
listRooms rooms =
    rooms
        |> .data
        |> List.sortBy .name
        |> sliceList 6
        |> List.map listRoomsSlice
        |> asGridContainer


listRecommendedRooms : RoomsData -> Html Msg
listRecommendedRooms rooms =
    listRooms { rooms | data = List.take 6 rooms.data }


listRoomsSlice : List Room -> Html Msg
listRoomsSlice rooms =
    Grid.row [] (List.map listSingleRoom rooms)


listSingleRoom : Room -> Grid.Column Msg
listSingleRoom room =
    Grid.col [ Col.lg2, Col.md4 ]
        [ div [ class "tile" ] [ displayRoomLabel room All ] ]


displayRoomLabel : Room -> FilterType -> Html Msg
displayRoomLabel room roomType =
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

        extras =
            let
                label =
                    case roomType of
                        All ->
                            []

                        Recommended ->
                            [ text "The most crowded right now" ]
            in
                p [ class "tile-room-description" ] label
    in
        a [ href url ]
            ([ p [ class "tile-room-name" ] [ text roomName ]
             , p [ class "tile-player-count" ] [ text playerCount ]
             ]
                ++ [ extras ]
            )
