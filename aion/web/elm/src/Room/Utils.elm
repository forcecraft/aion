module Room.Utils exposing (..)

import General.Models exposing (Model)
import RemoteData
import Room.Constants exposing (progressBarTimeout)
import Room.Models exposing (ProgressBar, ProgressBarState(Running, Stopped), Room, RoomId, RoomsData, withProgress, withRunning, withStart)
import Time exposing (Time, inMilliseconds)


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


progressBarTick : ProgressBar -> Time -> ProgressBar
progressBarTick progressBar time =
    let
        timeDiff =
            inMilliseconds time
                - progressBar.start

        nextProgress =
            timeDiff / progressBarTimeout * 100

        finishedLoading =
            nextProgress > 100

        ( running, progress ) =
            if finishedLoading then
                ( Stopped, nextProgress )
            else
                ( Running, nextProgress )
    in
        progressBar
            |> withRunning running
            |> withProgress progress
