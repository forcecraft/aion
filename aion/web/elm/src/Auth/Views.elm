module Auth.Views exposing (..)

import Auth.Models exposing (AuthData, LoginForm, RegistrationForm)
import Bootstrap.Badge as Badge
import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Forms
import General.Models exposing (Model)
import General.Notifications exposing (toastsConfig)
import Html exposing (Html, br, div, h4, text)
import Html.Attributes exposing (class, for)
import Msgs exposing (Msg(..))
import Toasty
import Toasty.Defaults


authView : Model -> Html Msg
authView model =
    div [ class "auth-container" ]
        [ case model.authData.displayLoginInsteadOfRegistration of
            True ->
                loginFormView model.authData.loginForm

            False ->
                registrationFormView model.authData.registrationForm
        , br [] []
        , authFormSwitch model.authData.formMsg
        , Toasty.view toastsConfig Toasty.Defaults.view ToastyMsg model.toasties
        ]



-- auth form switch section


authFormSwitch : String -> Html Msg
authFormSwitch formMsg =
    Button.button
        [ Button.roleLink
        , Button.onClick ChangeAuthForm
        ]
        [ text formMsg ]



-- login form section


loginFormView : LoginForm -> Html Msg
loginFormView loginForm =
    div [ class "login-container" ]
        [ h4 [] [ text "Log in:" ]
        , Form.form []
            [ emailLoginFormElement loginForm
            , passwordLoginFormElement loginForm
            , Button.button
                [ Button.info
                , Button.onClick Login
                ]
                [ text "submit" ]
            ]
        ]


emailLoginFormElement : Forms.Form -> Html Msg
emailLoginFormElement form =
    Form.group []
        [ Form.label [ for "email" ] [ text "Enter email below:" ]
        , Input.text
            [ Input.placeholder "john.doe@yahoo.com"
            , Input.onInput (UpdateLoginForm "email")
            , Input.value (Forms.formValue form "email")
            ]
        , Badge.pillInfo [] [ text (Forms.errorString form "email") ]
        ]


passwordLoginFormElement : Forms.Form -> Html Msg
passwordLoginFormElement form =
    Form.group []
        [ Form.label [ for "password" ] [ text "Enter password below:" ]
        , Input.password
            [ Input.placeholder "Your password..."
            , Input.onInput (UpdateLoginForm "password")
            , Input.value (Forms.formValue form "password")
            ]
        , Badge.pillInfo [] [ text (Forms.errorString form "password") ]
        ]



-- registration form section


registrationFormView : RegistrationForm -> Html Msg
registrationFormView registrationForm =
    div [ class "registration-container" ]
        [ h4 [] [ text "Register:" ]
        , Form.form []
            [ nameRegisterFormElement registrationForm
            , emailRegisterFormElement registrationForm
            , passwordRegisterFormElement registrationForm
            , Button.button
                [ Button.info
                , Button.onClick Register
                ]
                [ text "submit" ]
            ]
        ]


nameRegisterFormElement : Forms.Form -> Html Msg
nameRegisterFormElement form =
    Form.group []
        [ Form.label [ for "name" ] [ text "Enter username:" ]
        , Input.text
            [ Input.placeholder "John Doe"
            , Input.onInput (UpdateRegistrationForm "name")
            , Input.value (Forms.formValue form "name")
            ]
        , Badge.pillInfo [] [ text (Forms.errorString form "name") ]
        ]


emailRegisterFormElement : Forms.Form -> Html Msg
emailRegisterFormElement form =
    Form.group []
        [ Form.label [ for "email" ] [ text "Enter email below:" ]
        , Input.text
            [ Input.placeholder "john.doe@yahoo.com"
            , Input.onInput (UpdateRegistrationForm "email")
            , Input.value (Forms.formValue form "email")
            ]
        , Badge.pillInfo [] [ text (Forms.errorString form "email") ]
        ]


passwordRegisterFormElement : Forms.Form -> Html Msg
passwordRegisterFormElement form =
    Form.group []
        [ Form.label [ for "password" ] [ text "Enter password below:" ]
        , Input.password
            [ Input.placeholder "Your password..."
            , Input.onInput (UpdateRegistrationForm "password")
            , Input.value (Forms.formValue form "password")
            ]
        , Badge.pillInfo [] [ text (Forms.errorString form "password") ]
        ]
