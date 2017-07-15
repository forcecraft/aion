module General.Utils exposing (..)

import RemoteData exposing (WebData)
import Room.Models exposing (RoomsData)


getSubjectIdByName : WebData RoomsData -> String -> Int
getSubjectIdByName result roomName =
    case result of
        RemoteData.Success roomsData ->
            let
                filteredList =
                    List.filter (\room -> room.name == roomName) roomsData.data

                maybeRoomObject =
                    List.head filteredList

                roomObject =
                    Maybe.withDefault { id = 0, name = "" } maybeRoomObject
            in
                roomObject.id

        _ ->
            0
