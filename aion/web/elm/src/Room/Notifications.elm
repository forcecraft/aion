module Room.Notifications exposing (..)

import General.Models exposing (Model)
import General.Notifications exposing (addToast)
import Msgs exposing (Msg(..))
import Toasty
import Toasty.Defaults


incorrectAnswerToast : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
incorrectAnswerToast =
    addToast (Toasty.Defaults.Error "Error!" "Wrong answer!")


closeAnswerToast : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
closeAnswerToast =
    addToast (Toasty.Defaults.Warning "Close one!" "Your answer is almost correct!")


correctAnswerToast : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
correctAnswerToast =
    addToast (Toasty.Defaults.Success "Good Answer!" "Your answer is correct!")
