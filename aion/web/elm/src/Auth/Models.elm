module Auth.Models exposing (..)

import Forms


type alias AuthData =
    { loginForm : LoginForm
    , token : Maybe String
    , msg : String
    }


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
