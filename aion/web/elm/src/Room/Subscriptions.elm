module Room.Subscriptions exposing (..)

import General.Models exposing (Model)
import Room.Models exposing (RoomState(QuestionBreak, QuestionDisplayed))
import Room.Msgs exposing (RoomMsg(Tick))
import Time


subscriptions : Model -> Sub RoomMsg
subscriptions model =
    case model.roomState of
        QuestionDisplayed ->
            Time.every (20 * Time.millisecond) Tick

        QuestionBreak ->
            Sub.none
