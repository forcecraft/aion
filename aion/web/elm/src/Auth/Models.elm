module Auth.Models exposing (..)

import Auth.Constants exposing (loginFormMsg)
import Forms
import Navigation exposing (Location)
import Toasty
import Toasty.Defaults


type alias AuthData =
    { formMsg : String
    , location : Location
    , loginForm : LoginForm
    , msg : String
    , registrationForm : RegistrationForm
    , toasties : Toasty.Stack Toasty.Defaults.Toast
    , token : Maybe Token
    , unauthenticatedView : UnauthenticatedViewToggle
    }


initAuthData : Location -> Maybe Token -> AuthData
initAuthData location token =
    { formMsg = loginFormMsg
    , location = location
    , loginForm = Forms.initForm loginForm
    , msg = ""
    , registrationForm = Forms.initForm registrationForm
    , token = token
    , toasties = Toasty.initialState
    , unauthenticatedView = LoginView
    }


type UnauthenticatedViewToggle
    = LoginView
    | RegisterView


type alias Token =
    String



-- login form section


type alias LoginForm =
    Forms.Form


loginFormFields : List String
loginFormFields =
    [ "email", "password" ]


loginForm : List ( String, List Forms.FieldValidator )
loginForm =
    [ ( "email", [ Forms.validateExistence ] )
    , ( "password", [ Forms.validateExistence ] )
    ]



-- registration form section


type alias RegistrationForm =
    Forms.Form


registrationFormFields : List String
registrationFormFields =
    [ "name", "email", "password" ]


registrationForm : List ( String, List Forms.FieldValidator )
registrationForm =
    [ ( "name", [ Forms.validateExistence ] )
    , ( "email", [ Forms.validateExistence ] )
    , ( "password", [ Forms.validateExistence ] )
    ]


type alias RegistrationResultData =
    { token : Token
    }
