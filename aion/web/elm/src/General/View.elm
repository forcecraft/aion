module General.View exposing (..)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import General.Models exposing (Model)
import General.Utils exposing (sliceList)
import Html exposing (Html, a, br, button, div, h2, h4, i, img, li, p, span, text, ul)
import Html.Attributes exposing (class, href, src, style)
import Msgs exposing (Msg)
import RemoteData exposing (WebData)
import Room.Models exposing (RoomsData, Room)


notFoundView : Html Msg
notFoundView =
    div []
        [ text "Not found"
        ]


roomListView : Model -> Html Msg
roomListView model =
    div [] [ listRooms model.rooms ]


listRooms : WebData RoomsData -> Html Msg
listRooms response =
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success roomsData ->
            listAvailableRooms roomsData

        RemoteData.Failure error ->
            text (toString error)


listAvailableRooms : RoomsData -> Html Msg
listAvailableRooms roomsData =
    let
        sortedRooms =
            List.sortBy .name roomsData.data

        slicedRooms =
            sliceList 6 sortedRooms
    in
        Grid.container []
            (List.map listRoomsSlice slicedRooms)


listRoomsSlice : List Room -> Html Msg
listRoomsSlice rooms =
    Grid.row [] (List.map listSingleRoom rooms)


listSingleRoom : Room -> Grid.Column Msg
listSingleRoom room =
    Grid.col [ Col.lg2, Col.md4 ]
        [ div [ class "tile" ] [ displayRoomLabel room ] ]


displayRoomLabel : Room -> Html Msg
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
