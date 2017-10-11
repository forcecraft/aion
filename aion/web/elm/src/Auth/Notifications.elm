module Auth.Notifications exposing (..)

import General.Models exposing (Model)
import General.Notifications exposing (addToast)
import Msgs exposing (Msg(..))
import Toasty.Defaults


-- registration notifications


registrationErrorToast : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
registrationErrorToast =
    addToast (Toasty.Defaults.Error "Error!" "Failed to register :(")


registrationSuccessfulToast : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
registrationSuccessfulToast =
    addToast (Toasty.Defaults.Success "Success!" "Account created successfuly - proceed to Login.")
