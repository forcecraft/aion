module Auth.Models exposing (..)

import Forms


type alias AuthData =
    { loginForm : LoginForm
    , registrationForm : RegistrationForm
    , displayLoginInsteadOfRegistration : Bool
    , formMsg : String
    , token : Maybe String
    , msg : String
    }



-- login form section


type alias LoginForm =
    Forms.Form


loginFormPossibleFields : List String
loginFormPossibleFields =
    [ "email", "password" ]


loginForm : List ( String, List Forms.FieldValidator )
loginForm =
    [ ( "email", [ Forms.validateExistence ] )
    , ( "password", [ Forms.validateExistence ] )
    ]



-- registration form section


type alias RegistrationForm =
    Forms.Form


registrationFormPossibleFields : List String
registrationFormPossibleFields =
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
