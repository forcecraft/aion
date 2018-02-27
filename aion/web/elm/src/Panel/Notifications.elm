module Panel.Notifications exposing (..)

import General.Models exposing (Model)
import Html.Attributes exposing (class)
import Msgs exposing (Msg(..))
import Panel.Msgs exposing (PanelMsg(ToastyMsg))
import Toasty
import Toasty.Defaults


-- question form notifications


questionFormValidationErrorToast : ( Model, Cmd PanelMsg ) -> ( Model, Cmd PanelMsg )
questionFormValidationErrorToast =
    addToast (Toasty.Defaults.Error "Error!" "Submission form is not valid!")


questionCreationErrorToast : ( Model, Cmd PanelMsg ) -> ( Model, Cmd PanelMsg )
questionCreationErrorToast =
    addToast (Toasty.Defaults.Error "Error!" "Failed to create a question.")


questionCreationSuccessfulToast : ( Model, Cmd PanelMsg ) -> ( Model, Cmd PanelMsg )
questionCreationSuccessfulToast =
    addToast (Toasty.Defaults.Success "Success!" "Question created successfully.")



-- category form notifications


categoryFormValidationErrorToast : ( Model, Cmd PanelMsg ) -> ( Model, Cmd PanelMsg )
categoryFormValidationErrorToast =
    addToast (Toasty.Defaults.Error "Error!" "Category submission form is not valid!")


categoryCreationErrorToast : ( Model, Cmd PanelMsg ) -> ( Model, Cmd PanelMsg )
categoryCreationErrorToast =
    addToast (Toasty.Defaults.Error "Error!" "Failed to create a category.")


categoryCreationSuccessfulToast : ( Model, Cmd PanelMsg ) -> ( Model, Cmd PanelMsg )
categoryCreationSuccessfulToast =
    addToast (Toasty.Defaults.Success "Success!" "Category created successfully.")



-- room form notifications


roomFormValidationErrorToast : ( Model, Cmd PanelMsg ) -> ( Model, Cmd PanelMsg )
roomFormValidationErrorToast =
    addToast (Toasty.Defaults.Error "Error!" "Room submission form is not valid!")


roomCreationErrorToast : ( Model, Cmd PanelMsg ) -> ( Model, Cmd PanelMsg )
roomCreationErrorToast =
    addToast (Toasty.Defaults.Error "Error!" "Failed to create a room.")


roomCreationSuccessfulToast : ( Model, Cmd PanelMsg ) -> ( Model, Cmd PanelMsg )
roomCreationSuccessfulToast =
    addToast (Toasty.Defaults.Success "Success!" "Room created successfully.")


toastsConfig : Toasty.Config PanelMsg
toastsConfig =
    Toasty.Defaults.config
        |> Toasty.delay 1000
        |> Toasty.containerAttrs [ class "toasty-notification" ]


addToast : Toasty.Defaults.Toast -> ( Model, Cmd PanelMsg ) -> ( Model, Cmd PanelMsg )
addToast toast ( model, cmd ) =
    Toasty.addToast toastsConfig ToastyMsg toast ( model, cmd )
