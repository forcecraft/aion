module Panel.Notifications exposing (..)

import Html.Attributes exposing (class)
import Msgs exposing (Msg(..))
import Panel.Models exposing (PanelData)
import Panel.Msgs exposing (PanelMsg(ToastyMsg))
import Toasty
import Toasty.Defaults


-- question form notifications


questionFormValidationErrorToast : ( PanelData, Cmd PanelMsg ) -> ( PanelData, Cmd PanelMsg )
questionFormValidationErrorToast =
    addToast (Toasty.Defaults.Error "Error!" "Submission form is not valid!")


questionCreationErrorToast : ( PanelData, Cmd PanelMsg ) -> ( PanelData, Cmd PanelMsg )
questionCreationErrorToast =
    addToast (Toasty.Defaults.Error "Error!" "Failed to create a question.")


questionCreationSuccessfulToast : ( PanelData, Cmd PanelMsg ) -> ( PanelData, Cmd PanelMsg )
questionCreationSuccessfulToast =
    addToast (Toasty.Defaults.Success "Success!" "Question created successfully.")



-- category form notifications


categoryFormValidationErrorToast : ( PanelData, Cmd PanelMsg ) -> ( PanelData, Cmd PanelMsg )
categoryFormValidationErrorToast =
    addToast (Toasty.Defaults.Error "Error!" "Category submission form is not valid!")


categoryCreationErrorToast : ( PanelData, Cmd PanelMsg ) -> ( PanelData, Cmd PanelMsg )
categoryCreationErrorToast =
    addToast (Toasty.Defaults.Error "Error!" "Failed to create a category.")


categoryCreationSuccessfulToast : ( PanelData, Cmd PanelMsg ) -> ( PanelData, Cmd PanelMsg )
categoryCreationSuccessfulToast =
    addToast (Toasty.Defaults.Success "Success!" "Category created successfully.")



-- room form notifications


roomFormValidationErrorToast : ( PanelData, Cmd PanelMsg ) -> ( PanelData, Cmd PanelMsg )
roomFormValidationErrorToast =
    addToast (Toasty.Defaults.Error "Error!" "Room submission form is not valid!")


roomCreationErrorToast : ( PanelData, Cmd PanelMsg ) -> ( PanelData, Cmd PanelMsg )
roomCreationErrorToast =
    addToast (Toasty.Defaults.Error "Error!" "Failed to create a room.")


roomCreationSuccessfulToast : ( PanelData, Cmd PanelMsg ) -> ( PanelData, Cmd PanelMsg )
roomCreationSuccessfulToast =
    addToast (Toasty.Defaults.Success "Success!" "Room created successfully.")


toastsConfig : Toasty.Config PanelMsg
toastsConfig =
    Toasty.Defaults.config
        |> Toasty.delay 1000
        |> Toasty.containerAttrs [ class "toasty-notification" ]


addToast : Toasty.Defaults.Toast -> ( PanelData, Cmd PanelMsg ) -> ( PanelData, Cmd PanelMsg )
addToast toast ( model, cmd ) =
    Toasty.addToast toastsConfig ToastyMsg toast ( model, cmd )
