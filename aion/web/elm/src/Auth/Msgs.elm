module Auth.Msgs exposing (..)

import Auth.Models exposing (RegistrationResultData)
import Http
import RemoteData exposing (WebData)
import Toasty
import Toasty.Defaults


type AuthMsg
    = Login
    | LoginResult (Result Http.Error String)
    | Register
    | RegistrationResult (WebData RegistrationResultData)
    | ChangeAuthForm
    | UpdateLoginForm String String
    | UpdateRegistrationForm String String
    | ToastyMsg (Toasty.Msg Toasty.Defaults.Toast)
