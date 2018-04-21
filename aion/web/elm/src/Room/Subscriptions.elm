module Room.Subscriptions exposing (..)

import Room.Models exposing (RoomData, RoomState(QuestionBreak, QuestionDisplayed))
import Room.Msgs exposing (RoomMsg(Tick))
import Time


subscriptions : RoomData -> Sub RoomMsg
subscriptions model =
    case model.roomState of
        QuestionDisplayed ->
            Time.every (20 * Time.millisecond) Tick

        QuestionBreak ->
            Sub.none
