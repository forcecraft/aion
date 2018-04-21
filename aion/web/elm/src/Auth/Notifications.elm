module Auth.Notifications exposing (..)

import Auth.Models exposing (AuthData)
import Auth.Msgs exposing (AuthMsg(ToastyMsg))
import Html.Attributes exposing (class)
import Toasty
import Toasty.Defaults


-- registration notifications


registrationErrorToast : ( AuthData, Cmd AuthMsg ) -> ( AuthData, Cmd AuthMsg )
registrationErrorToast =
    addToast (Toasty.Defaults.Error "Error!" "Failed to register :(")



-- login notifications


loginErrorToast : ( AuthData, Cmd AuthMsg ) -> ( AuthData, Cmd AuthMsg )
loginErrorToast =
    addToast (Toasty.Defaults.Error "Error!" "Failed to login :(")


toastsConfig : Toasty.Config AuthMsg
toastsConfig =
    Toasty.Defaults.config
        |> Toasty.delay 1000
        |> Toasty.containerAttrs [ class "toasty-notification" ]


addToast : Toasty.Defaults.Toast -> ( AuthData, Cmd AuthMsg ) -> ( AuthData, Cmd AuthMsg )
addToast toast ( model, cmd ) =
    Toasty.addToast toastsConfig ToastyMsg toast ( model, cmd )
