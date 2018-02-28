module Room.Notifications exposing (..)

import General.Models exposing (Model)
import Html.Attributes exposing (class)
import Room.Msgs exposing (RoomMsg(ToastyMsg))
import Toasty
import Toasty.Defaults


incorrectAnswerToast : ( Model, Cmd RoomMsg ) -> ( Model, Cmd RoomMsg )
incorrectAnswerToast =
    addToast (Toasty.Defaults.Error "Error!" "Wrong answer!")


closeAnswerToast : ( Model, Cmd RoomMsg ) -> ( Model, Cmd RoomMsg )
closeAnswerToast =
    addToast (Toasty.Defaults.Warning "Close one!" "Your answer is almost correct!")


correctAnswerToast : ( Model, Cmd RoomMsg ) -> ( Model, Cmd RoomMsg )
correctAnswerToast =
    addToast (Toasty.Defaults.Success "Good Answer!" "Your answer is correct!")


toastsConfig : Toasty.Config RoomMsg
toastsConfig =
    Toasty.Defaults.config
        |> Toasty.delay 1000
        |> Toasty.containerAttrs [ class "toasty-notification" ]


addToast : Toasty.Defaults.Toast -> ( Model, Cmd RoomMsg ) -> ( Model, Cmd RoomMsg )
addToast toast ( model, cmd ) =
    Toasty.addToast toastsConfig ToastyMsg toast ( model, cmd )
