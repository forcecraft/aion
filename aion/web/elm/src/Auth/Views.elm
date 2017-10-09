module Auth.Views exposing (..)

import Auth.Models exposing (LoginForm)
import Bootstrap.Badge as Badge
import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Forms
import General.Models exposing (Model)
import Html exposing (Html, br, div, h4, text)
import Html.Attributes exposing (class, for)
import Msgs exposing (Msg(..))


authView : Model -> Html Msg
authView model =
    div [ class "auth-container" ]
        [ case model.authData.displayLoginInsteadOfRegistration of
            True ->
                loginFormView model.authData.loginForm

            False ->
                div [] []
        , br [] []
        , Button.button
            [ Button.roleLink
            , Button.onClick ChangeAuthForm
            ]
            [ text model.authData.formMsg ]
        ]



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
