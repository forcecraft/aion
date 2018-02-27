module Auth.Update exposing (..)

import Auth.Api exposing (registerUser, submitCredentials)
import Auth.Models exposing (UnauthenticatedViewToggle(LoginView, RegisterView))
import Auth.Notifications exposing (loginErrorToast, registrationErrorToast)
import Forms
import General.Constants exposing (loginFormMsg, registerFormMsg)
import General.Models exposing (Model)
import Msgs exposing (Msg(ChangeAuthForm, Login, LoginResult, Register, RegistrationResult))
import RemoteData
import Socket exposing (initSocket)
import UpdateHelpers exposing (postTokenActions, updateForm)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Login ->
            model
                ! [ submitCredentials model.location model.authData.loginForm ]

        LoginResult res ->
            let
                oldAuthData =
                    model.authData
            in
                case res of
                    Ok token ->
                        { model
                            | authData = { oldAuthData | token = Just token, msg = "" }
                            , socket = initSocket token model.location
                        }
                            ! postTokenActions token model.location

                    Err err ->
                        { model | authData = { oldAuthData | msg = toString err } }
                            ! []
                            |> loginErrorToast

        Register ->
            model ! [ registerUser model.location model.authData.registrationForm ]

        RegistrationResult response ->
            case response of
                RemoteData.Success responseData ->
                    let
                        token =
                            responseData.token

                        oldAuthData =
                            model.authData

                        oldRegistrationForm =
                            oldAuthData.registrationForm

                        newRegistrationForm =
                            updateForm "name" "" oldRegistrationForm
                                |> updateForm "email" ""
                                |> updateForm "password" ""
                    in
                        { model
                            | authData = { oldAuthData | registrationForm = newRegistrationForm, token = Just token }
                            , socket = initSocket token model.location
                        }
                            ! postTokenActions token model.location

                _ ->
                    model
                        ! []
                        |> registrationErrorToast

        Logout ->
            let
                oldAuthData =
                    model.authData
            in
                { model | authData = { oldAuthData | token = Nothing } } ! [ check "" ]

        ChangeAuthForm ->
            let
                oldAuthData =
                    model.authData

                oldUnauthenticatedView =
                    oldAuthData.unauthenticatedView
            in
                case oldUnauthenticatedView of
                    LoginView ->
                        { model
                            | authData =
                                { oldAuthData
                                    | unauthenticatedView = RegisterView
                                    , formMsg = registerFormMsg
                                }
                        }
                            ! []

                    RegisterView ->
                        { model
                            | authData =
                                { oldAuthData
                                    | unauthenticatedView = LoginView
                                    , formMsg = loginFormMsg
                                }
                        }
                            ! []

        -- Forms
        UpdateLoginForm name value ->
            let
                oldAuthData =
                    model.authData

                loginForm =
                    oldAuthData.loginForm

                updatedLoginForm =
                    Forms.updateFormInput loginForm name value
            in
                { model
                    | authData =
                        { oldAuthData | loginForm = updatedLoginForm }
                }
                    ! []

        UpdateRegistrationForm name value ->
            let
                oldAuthData =
                    model.authData

                registrationForm =
                    oldAuthData.registrationForm

                updatedRegistrationForm =
                    Forms.updateFormInput registrationForm name value
            in
                { model
                    | authData =
                        { oldAuthData | registrationForm = updatedRegistrationForm }
                }
                    ! []
