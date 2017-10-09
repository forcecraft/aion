module Auth.Views exposing (..)

import Auth.Models exposing (AuthData, LoginForm, RegistrationForm)
import Bootstrap.Badge as Badge
import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Forms
import Html exposing (Html, br, div, h4, text)
import Html.Attributes exposing (class, for)
import Msgs exposing (Msg(..))


--TODO: make form creation a function


authView : AuthData -> Html Msg
authView authData =
    div [ class "auth-container" ]
        [ case authData.displayLoginInsteadOfRegistration of
            True ->
                loginFormView authData.loginForm

            False ->
                registrationFormView authData.registrationForm
        , br [] []
        , authFormSwitch authData.formMsg
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
registrationFormView registerForm =
    div [ class "registration-container" ]
        [ h4 [] [ text "Register:" ]
        , Form.form []
            [ nameRegisterFormElement registerForm
            , emailRegisterFormElement registerForm
            , passwordRegisterFormElement registerForm
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
            , Input.onInput (UpdateLoginForm "name")
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
            , Input.onInput (UpdateLoginForm "email")
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
            , Input.onInput (UpdateLoginForm "password")
            , Input.value (Forms.formValue form "password")
            ]
        , Badge.pillInfo [] [ text (Forms.errorString form "password") ]
        ]
