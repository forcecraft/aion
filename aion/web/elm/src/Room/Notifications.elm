module Room.Notifications exposing (..)

import General.Models exposing (Model)
import General.Notifications exposing (addToast)
import Msgs exposing (Msg(..))
import Toasty.Defaults


incorrectAnswerToast : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
incorrectAnswerToast =
    addToast (Toasty.Defaults.Error "Error!" "Wrong Answer")


closeAnswerToast : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
closeAnswerToast =
    addToast (Toasty.Defaults.Warning "Close one!" "Your Answer is Almost Correct")


correctAnswerToast : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
correctAnswerToast =
    addToast (Toasty.Defaults.Success "Good Answer!" "Your Answer is Correct")
