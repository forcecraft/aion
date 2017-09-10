module Panel.Validators exposing (..)

import Forms
import Regex


questionValidations : List Forms.FieldValidator
questionValidations =
    let
        questionRegex =
            "([^.?!]*)\\?"
    in
        [ Forms.validateExistence
        , validateRegularExpression questionRegex
        ]


answersValidations : List Forms.FieldValidator
answersValidations =
    let
        answersRegex =
            "\\w+(\\s\\w+)*(,\\w+(\\s\\w+)*)*"
    in
        [ Forms.validateExistence
        , validateRegularExpression answersRegex
        ]


categoryValidations : List Forms.FieldValidator
categoryValidations =
    [ Forms.validateExistence ]


categoryNameValidations : List Forms.FieldValidator
categoryNameValidations =
    [ Forms.validateExistence
    , Forms.validateMaxLength 24
    ]


validateRegularExpression : String -> String -> Maybe String
validateRegularExpression regex string =
    let
        matches =
            Regex.find Regex.All (Regex.regex regex) string
    in
        case List.head matches of
            Just match ->
                if String.length match.match == String.length string then
                    Nothing
                else
                    Just "invalid string format"

            Nothing ->
                Just "invalid string format"
