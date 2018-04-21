module Auth.Update exposing (..)

import Auth.Api exposing (registerUser, submitCredentials)
import Auth.Constants exposing (loginFormMsg, registerFormMsg)
import Auth.Models exposing (AuthData, UnauthenticatedViewToggle(LoginView, RegisterView))
import Auth.Msgs exposing (AuthMsg(ChangeAuthForm, Login, LoginResult, Register, RegistrationResult, ToastyMsg, UpdateLoginForm, UpdateRegistrationForm))
import Auth.Notifications exposing (loginErrorToast, registrationErrorToast, toastsConfig)
import Forms
import RemoteData
import Toasty
import UpdateHelpers exposing (postTokenActions, updateForm)


update : AuthMsg -> AuthData -> ( AuthData, Cmd AuthMsg )
update msg model =
    case msg of
        Login ->
            model
                ! [ submitCredentials model.location model.loginForm ]

        LoginResult res ->
            case res of
                Ok token ->
                    { model | token = Just token, msg = "" } ! []

                Err err ->
                    { model | msg = toString err } ! [] |> loginErrorToast

        Register ->
            model ! [ registerUser model.location model.registrationForm ]

        RegistrationResult response ->
            case response of
                RemoteData.Success responseData ->
                    let
                        token =
                            responseData.token

                        newRegistrationForm =
                            updateForm "name" "" model.registrationForm
                                |> updateForm "email" ""
                                |> updateForm "password" ""
                    in
                        { model | registrationForm = newRegistrationForm, token = Just token } ! []

                _ ->
                    model ! [] |> registrationErrorToast

        ChangeAuthForm ->
            case model.unauthenticatedView of
                LoginView ->
                    { model | unauthenticatedView = RegisterView, formMsg = registerFormMsg } ! []

                RegisterView ->
                    { model | unauthenticatedView = LoginView, formMsg = loginFormMsg } ! []

        UpdateLoginForm name value ->
            let
                updatedLoginForm =
                    Forms.updateFormInput model.loginForm name value
            in
                { model | loginForm = updatedLoginForm } ! []

        UpdateRegistrationForm name value ->
            let
                updatedRegistrationForm =
                    Forms.updateFormInput model.registrationForm name value
            in
                { model | registrationForm = updatedRegistrationForm } ! []

        -- Toasty
        ToastyMsg subMsg ->
            Toasty.update toastsConfig ToastyMsg subMsg model
