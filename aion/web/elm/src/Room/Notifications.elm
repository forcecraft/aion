module Room.Notifications exposing (..)

import General.Models exposing (Model)
import Msgs exposing (Msg(..))
import Toasty
import Toasty.Defaults


myConfig : Toasty.Config Msg
myConfig =
    Toasty.Defaults.config
        |> Toasty.delay 5000


addToast : Toasty.Defaults.Toast -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
addToast toast ( model, cmd ) =
    Toasty.addToast myConfig ToastyMsg toast ( model, cmd )


incorrectAnswerToast : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
incorrectAnswerToast =
    addToast (Toasty.Defaults.Error "Error!" "Wrong Answer")


closeAnswerToast : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
closeAnswerToast =
    addToast (Toasty.Defaults.Warning "Close one!" "Your Answer is Almost Correct")


correctAnswerToast : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
correctAnswerToast =
    addToast (Toasty.Defaults.Success "Good Answer!" "Your Answer is Correct")
