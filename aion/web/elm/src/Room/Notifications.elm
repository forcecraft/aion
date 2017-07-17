module Room.Notifications exposing (..)

import Toasty.Defaults
import Toasty
import Msgs exposing (Msg(..))
import General.Models exposing (Model)

myConfig : Toasty.Config Msg
myConfig =
    Toasty.Defaults.config
        |> Toasty.delay 5000


addToast : Toasty.Defaults.Toast -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
addToast toast ( model, cmd ) =
    Toasty.addToast myConfig ToastyMsg toast ( model, cmd )


wrongAnswerToast : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
wrongAnswerToast = addToast (Toasty.Defaults.Error "Error!" "Wrong Answer")
