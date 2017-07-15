module General.Utils exposing (..)

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
