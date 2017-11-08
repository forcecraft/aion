module Auth.View exposing (..)

import Auth.Models exposing (AuthData, LoginForm, RegistrationForm, UnauthenticatedViewToggle(LoginView, RegisterView))
import Bootstrap.Badge as Badge
import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Grid as Grid
import Forms
import General.Models exposing (Model)
import General.Notifications exposing (toastsConfig)
import Html exposing (Html, br, div, h2, text)
import Html.Attributes exposing (class, for)
import Msgs exposing (Msg(..))
import Toasty
import Toasty.Defaults


authView : Model -> Html Msg
authView model =
    Grid.container [ class "auth-container" ]
        [ Grid.container []
            [ Grid.row []
                [ Grid.col []
                    [ case model.authData.unauthenticatedView of
                        LoginView ->
                            loginFormView model.authData.loginForm model.authData.formMsg

                        RegisterView ->
                            registrationFormView model.authData.registrationForm model.authData.formMsg
                    ]
                , Grid.col [] []
                ]
            ]
        , Toasty.view toastsConfig Toasty.Defaults.view ToastyMsg model.toasties
        ]



-- auth form switch section


authFormToggle : String -> Html Msg
authFormToggle formMsg =
    Button.button
        [ Button.attrs [ class "auth-toggle-button" ]
        , Button.roleLink
        , Button.onClick ChangeAuthForm
        ]
        [ text formMsg ]



-- login form section


loginFormView : LoginForm -> String -> Html Msg
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
                ]
                [ text "submit" ]
            ]
        ]


emailLoginFormElement : Forms.Form -> Html Msg
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


passwordLoginFormElement : Forms.Form -> Html Msg
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


registrationFormView : RegistrationForm -> String -> Html Msg
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
                ]
                [ text "submit" ]
            ]
        ]


nameRegisterFormElement : Forms.Form -> Html Msg
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


emailRegisterFormElement : Forms.Form -> Html Msg
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


passwordRegisterFormElement : Forms.Form -> Html Msg
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
