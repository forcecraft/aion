module General.View exposing (..)

import Array
import Bootstrap.Button as Button
import Bootstrap.Card as Card
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import General.Constants exposing (hostname)
import General.Models exposing (Model)
import General.Utils exposing (sliceList, roomsViewColorList, roomsDefaultColor)
import Html exposing (Html, a, button, div, h2, h3, i, img, li, p, text, ul)
import Html.Attributes exposing (class, href, src, style)
import Msgs exposing (Msg)
import Routing exposing (panelPath, roomsPath, userPath)
import RemoteData exposing (WebData)
import Room.Models exposing (RoomsData, Room)


notFoundView : Html Msg
notFoundView =
    div []
        [ text "Not found"
        ]


homeView : Model -> Html Msg
homeView model =
    div []
        -- use grid columns you feggit
        [ h3 [ class "welcome-title" ] [ text "Welcome to Aion!" ]
        , ul [ style [ ( "padding-top", "60px" ) ] ]
            [ simpleCard (hostname ++ "svg/trophy.svg") "Play a game" "Find a room for yourself and check your knowledge versus other players." "#/rooms" "Browse rooms"
            , simpleCard (hostname ++ "svg/tasks.svg") "Panel" "Create new rooms, new categories and new questions." "#/panel" "Visit panel"
            , simpleCard (hostname ++ "svg/diploma.svg") "Profile" "Check your profile, gaming history and statistics." "#/profile" "Go to profile"
            ]
        ]


simpleCard : String -> String -> String -> String -> String -> Html Msg
simpleCard image cardTitle cardText cardLink buttonText =
    Card.config [ Card.attrs [ style [ ( "width", "21.5rem" ), ( "float", "left" ) ] ] ]
        |> Card.header [ class "text-center" ]
            [ img [ src image ] [] ]
        |> Card.block []
            [ Card.titleH4 [] [ text cardTitle ]
            , Card.text [] [ text cardText ]
            , Card.custom <|
                Button.linkButton [ Button.success, Button.attrs [ href cardLink ] ] [ text buttonText ]
            ]
        |> Card.view


roomListView : Model -> Html Msg
roomListView model =
    div []
        [ div [ class "room-select-title" ] [ h2 [] [ text "Select Room To Play:" ] ]
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
        [ div
            [ style [ ( "backgroundColor", generateColor room ) ]
            , class "tile"
            ]
            [ a [ (href ("#rooms/" ++ (toString room.id))) ] [ text room.name ]
            ]
        ]


generateColor : Room -> String
generateColor room =
    let
        generatedIndex =
            room.id * String.length (room.name) % 7

        pickedColor =
            Array.get generatedIndex roomsViewColorList
    in
        case pickedColor of
            Just color ->
                color

            Nothing ->
                roomsDefaultColor
