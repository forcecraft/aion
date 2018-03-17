module Room.Utils exposing (..)

import Lobby.Models exposing (Room, RoomId)
import RemoteData
import Room.Constants exposing (progressBarTimeout)
import Room.Models exposing (ProgressBar, ProgressBarState(Running, Stopped), RoomData, withProgress, withRunning, withStart)
import Time exposing (Time, inMilliseconds)


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
