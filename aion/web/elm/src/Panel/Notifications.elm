module Panel.Notifications exposing (..)

import General.Models exposing (Model)
import General.Notifications exposing (addToast)
import Msgs exposing (Msg(..))
import Toasty.Defaults


questionFormValidationErrorToast : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
questionFormValidationErrorToast =
    addToast (Toasty.Defaults.Error "Error!" "Submission form is not valid!")


questionCreationErrorToast : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
questionCreationErrorToast =
    addToast (Toasty.Defaults.Error "Error!" "Failed to create a question.")


questionCreationSuccessfulToast : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
questionCreationSuccessfulToast =
    addToast (Toasty.Defaults.Success "Success!" "Question created successfully.")
