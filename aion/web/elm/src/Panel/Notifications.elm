module Panel.Notifications exposing (..)

import General.Models exposing (Model)
import General.Notifications exposing (addToast)
import Msgs exposing (Msg(..))
import Toasty.Defaults


categoryFormValidationErrorToast : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
categoryFormValidationErrorToast =
    addToast (Toasty.Defaults.Error "Error!" "Category submission form is not valid!")


categoryCreationErrorToast : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
categoryCreationErrorToast =
    addToast (Toasty.Defaults.Error "Error!" "Failed to create a category.")


categoryCreationSuccessfulToast : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
categoryCreationSuccessfulToast =
    addToast (Toasty.Defaults.Success "Success!" "Category created successfully.")
