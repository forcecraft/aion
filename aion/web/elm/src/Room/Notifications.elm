module Room.Notifications exposing (..)

import Html.Attributes exposing (class)
import Room.Models exposing (RoomData)
import Room.Msgs exposing (RoomMsg(ToastyMsg))
import Toasty
import Toasty.Defaults


incorrectAnswerToast : ( RoomData, Cmd RoomMsg ) -> ( RoomData, Cmd RoomMsg )
incorrectAnswerToast =
    addToast (Toasty.Defaults.Error "Error!" "Wrong answer!")


closeAnswerToast : ( RoomData, Cmd RoomMsg ) -> ( RoomData, Cmd RoomMsg )
closeAnswerToast =
    addToast (Toasty.Defaults.Warning "Close one!" "Your answer is almost correct!")


correctAnswerToast : ( RoomData, Cmd RoomMsg ) -> ( RoomData, Cmd RoomMsg )
correctAnswerToast =
    addToast (Toasty.Defaults.Success "Good Answer!" "Your answer is correct!")


toastsConfig : Toasty.Config RoomMsg
toastsConfig =
    Toasty.Defaults.config
        |> Toasty.delay 1000
        |> Toasty.containerAttrs [ class "toasty-notification" ]


addToast : Toasty.Defaults.Toast -> ( RoomData, Cmd RoomMsg ) -> ( RoomData, Cmd RoomMsg )
addToast toast ( model, cmd ) =
    Toasty.addToast toastsConfig ToastyMsg toast ( model, cmd )
