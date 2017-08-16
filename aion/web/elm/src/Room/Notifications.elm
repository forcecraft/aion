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



-- answer feedback toasts


incorrectAnswerToast : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
incorrectAnswerToast =
    addToast (Toasty.Defaults.Error "Error!" "Wrong answer!")


closeAnswerToast : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
closeAnswerToast =
    addToast (Toasty.Defaults.Warning "Close one!" "Your answer is almost correct!")


correctAnswerToast : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
correctAnswerToast =
    addToast (Toasty.Defaults.Success "Good Answer!" "Your answer is correct!")



-- question creation


questionFormValidationErrorToast : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
questionFormValidationErrorToast =
    addToast (Toasty.Defaults.Error "Error!" "Submission form is not valid!")


questionCreationErrorToast : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
questionCreationErrorToast =
    addToast (Toasty.Defaults.Error "Error!" "Failed to create a question.")


questionCreationSuccessfulToast : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
questionCreationSuccessfulToast =
    addToast (Toasty.Defaults.Success "Success!" "Question created successfully.")
