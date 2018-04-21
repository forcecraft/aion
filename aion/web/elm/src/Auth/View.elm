module Auth.View exposing (..)

import Auth.Constants exposing (authPageRightColumnContent)
import Auth.Models exposing (AuthData, LoginForm, RegistrationForm, UnauthenticatedViewToggle(LoginView, RegisterView))
import Auth.Msgs exposing (AuthMsg(ChangeAuthForm, Login, Register, ToastyMsg, UpdateLoginForm, UpdateRegistrationForm))
import Auth.Notifications exposing (toastsConfig)
import Bootstrap.Badge as Badge
import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Grid as Grid
import Forms
import Html exposing (Html, br, div, h2, p, span, text)
import Html.Attributes exposing (class, for)
import Toasty
import Toasty.Defaults


authView : AuthData -> Html AuthMsg
authView model =
    let
        unauthenticatedView =
            model.unauthenticatedView

        loginForm =
            model.loginForm

        registrationForm =
            model.registrationForm

        formMsg =
            model.formMsg
    in
        Grid.container [ class "auth-container" ]
            [ Grid.container []
                [ Grid.row []
                    [ Grid.col [] [ authForm unauthenticatedView loginForm registrationForm formMsg ]
                    , Grid.col [] [ authPageRightColumn ]
                    ]
                ]
            , Toasty.view toastsConfig Toasty.Defaults.view ToastyMsg model.toasties
            ]


authForm : UnauthenticatedViewToggle -> LoginForm -> RegistrationForm -> String -> Html AuthMsg
authForm unauthenticatedView loginForm registrationForm formMsg =
    case unauthenticatedView of
        LoginView ->
            loginFormView loginForm formMsg

        RegisterView ->
            registrationFormView registrationForm formMsg


authPageRightColumn : Html AuthMsg
authPageRightColumn =
    div []
        [ h2 []
            [ text "Welcome to "
            , span [ class "highlight-aion" ] [ text "Aion" ]
            , text "!"
            ]
        , div
            [ class "auth-page-content" ]
            (List.map
                (\paragraph -> p [] [ text paragraph ])
                authPageRightColumnContent
            )
        ]



-- auth form switch section


authFormToggle : String -> Html AuthMsg
authFormToggle formMsg =
    Button.button
        [ Button.attrs [ class "auth-toggle-button" ]
        , Button.roleLink
        , Button.onClick ChangeAuthForm
        ]
        [ text formMsg ]



-- login form section


loginFormView : LoginForm -> String -> Html AuthMsg
loginFormView loginForm formMsg =
    div [ class "login-container" ]
        [ h2 [] [ text "Log in" ]
        , authFormToggle formMsg
        , Form.form []
            [ emailLoginFormElement loginForm
            , passwordLoginFormElement loginForm
            , Button.button
                [ Button.success
                , Button.onClick Login
                , Button.attrs [ class "auth-button" ]
                ]
                [ text "Sign in" ]
            ]
        ]


emailLoginFormElement : Forms.Form -> Html AuthMsg
emailLoginFormElement form =
    Form.group []
        [ Form.label [ for "email" ] [ text "Email" ]
        , Input.text
            [ Input.placeholder "john.doe@yahoo.com"
            , Input.onInput (UpdateLoginForm "email")
            , Input.value (Forms.formValue form "email")
            ]
        , Badge.pillSuccess [] [ text (Forms.errorString form "email") ]
        ]


passwordLoginFormElement : Forms.Form -> Html AuthMsg
passwordLoginFormElement form =
    Form.group []
        [ Form.label [ for "password" ] [ text "Password" ]
        , Input.password
            [ Input.placeholder "Your password..."
            , Input.onInput (UpdateLoginForm "password")
            , Input.value (Forms.formValue form "password")
            ]
        , Badge.pillSuccess [] [ text (Forms.errorString form "password") ]
        ]



-- registration form section


registrationFormView : RegistrationForm -> String -> Html AuthMsg
registrationFormView registrationForm formMsg =
    div [ class "registration-container" ]
        [ h2 [] [ text "Register" ]
        , authFormToggle formMsg
        , Form.form []
            [ emailRegisterFormElement registrationForm
            , passwordRegisterFormElement registrationForm
            , nameRegisterFormElement registrationForm
            , Button.button
                [ Button.success
                , Button.onClick Register
                , Button.attrs [ class "auth-button" ]
                ]
                [ text "Sign up" ]
            ]
        ]


nameRegisterFormElement : Forms.Form -> Html AuthMsg
nameRegisterFormElement form =
    Form.group []
        [ Form.label [ for "name" ] [ text "Username" ]
        , Input.text
            [ Input.placeholder "John Doe"
            , Input.onInput (UpdateRegistrationForm "name")
            , Input.value (Forms.formValue form "name")
            ]
        , Badge.pillSuccess [] [ text (Forms.errorString form "name") ]
        ]


emailRegisterFormElement : Forms.Form -> Html AuthMsg
emailRegisterFormElement form =
    Form.group []
        [ Form.label [ for "email" ] [ text "Email" ]
        , Input.text
            [ Input.placeholder "john.doe@yahoo.com"
            , Input.onInput (UpdateRegistrationForm "email")
            , Input.value (Forms.formValue form "email")
            ]
        , Badge.pillSuccess [] [ text (Forms.errorString form "email") ]
        ]


passwordRegisterFormElement : Forms.Form -> Html AuthMsg
passwordRegisterFormElement form =
    Form.group []
        [ Form.label [ for "password" ] [ text "Password" ]
        , Input.password
            [ Input.placeholder "Your password..."
            , Input.onInput (UpdateRegistrationForm "password")
            , Input.value (Forms.formValue form "password")
            ]
        , Badge.pillSuccess [] [ text (Forms.errorString form "password") ]
        ]
