module Auth.Models exposing (..)

import Forms


type alias AuthData =
    { loginForm : LoginForm
    , registrationForm : RegistrationForm
    , unauthenticatedView : UnauthenticatedViewToggle
    , formMsg : String
    , token : Maybe String
    , msg : String
    }


type UnauthenticatedViewToggle
    = LoginView
    | RegisterView



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
    { token : String
    }
