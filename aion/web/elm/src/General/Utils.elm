module General.Utils exposing (..)

import Array exposing (Array, fromList)
import RemoteData exposing (WebData)
import Room.Models exposing (RoomsData)


getSubjectIdByName : WebData RoomsData -> String -> Int
getSubjectIdByName result roomName =
    case result of
        RemoteData.Success roomsData ->
            let
                roomObject =
                    roomsData.data
                        |> List.filter (\room -> room.name == roomName)
                        |> List.head
                        |> Maybe.withDefault { id = 0, name = "" }
            in
                roomObject.id

        _ ->
            0


roomsViewColorList : Array String
roomsViewColorList =
    fromList [ "#1abc9c", "#2ecc71", "#9b59b6", "#34495e", "#f1c40f", "#e74c3c", "#d35400" ]


roomsDefaultColor : String
roomsDefaultColor =
    "#1abc9c"


sliceList : Int -> List a -> List (List a)
sliceList n list =
    case ( n, list ) of
        ( 0, list ) ->
            [ list ]

        ( n, [] ) ->
            []

        ( n, list ) ->
            (List.take n list) :: (sliceList n (List.drop n list))
