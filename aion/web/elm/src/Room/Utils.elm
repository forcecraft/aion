module Room.Utils exposing (..)

import General.Models exposing (Model)
import RemoteData
import Room.Models exposing (Room, RoomId, RoomsData)


getRoomNameById : Model -> RoomId -> String
getRoomNameById model roomId =
    case (getRoomById model roomId) of
        Just room ->
            "Room# " ++ room.name

        _ ->
            "Room Not Found"


getRoomById : Model -> RoomId -> Maybe Room
getRoomById model roomId =
    List.filter (\room -> room.id == roomId) (getRoomList model)
        |> List.head


getRoomList : Model -> List Room
getRoomList model =
    case model.rooms of
        RemoteData.Success roomsData ->
            roomsData.data

        _ ->
            []
