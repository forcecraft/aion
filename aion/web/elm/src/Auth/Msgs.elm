module Auth.Msgs exposing (..)

import Auth.Models exposing (RegistrationResultData)
import Http
import RemoteData exposing (WebData)


type AuthMsg
    = Login
    | LoginResult (Result Http.Error String)
    | Register
    | RegistrationResult (WebData RegistrationResultData)
    | Logout
    | ChangeAuthForm
    | UpdateLoginForm String String
    | UpdateRegistrationForm String String
