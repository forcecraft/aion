module Room.Subscriptions exposing (..)

import General.Models exposing (Model)
import Msgs
import Room.Models exposing (RoomState(QuestionBreak, QuestionDisplayed))
import Time


subscriptions : Model -> Sub Msgs.Msg
subscriptions model =
    case model.roomState of
        QuestionDisplayed ->
            Time.every Time.millisecond Msgs.Tick

        QuestionBreak ->
            Sub.none
