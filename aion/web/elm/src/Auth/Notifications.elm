module Auth.Notifications exposing (..)

import Auth.Msgs exposing (AuthMsg(ToastyMsg))
import General.Models exposing (Model)
import Html.Attributes exposing (class)
import Toasty
import Toasty.Defaults


-- registration notifications


registrationErrorToast : ( Model, Cmd AuthMsg ) -> ( Model, Cmd AuthMsg )
registrationErrorToast =
    addToast (Toasty.Defaults.Error "Error!" "Failed to register :(")



-- login notifications


loginErrorToast : ( Model, Cmd AuthMsg ) -> ( Model, Cmd AuthMsg )
loginErrorToast =
    addToast (Toasty.Defaults.Error "Error!" "Failed to login :(")


toastsConfig : Toasty.Config AuthMsg
toastsConfig =
    Toasty.Defaults.config
        |> Toasty.delay 1000
        |> Toasty.containerAttrs [ class "toasty-notification" ]


addToast : Toasty.Defaults.Toast -> ( Model, Cmd AuthMsg ) -> ( Model, Cmd AuthMsg )
addToast toast ( model, cmd ) =
    Toasty.addToast toastsConfig ToastyMsg toast ( model, cmd )
