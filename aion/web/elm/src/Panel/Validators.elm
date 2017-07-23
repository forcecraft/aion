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
            "\\w+(,\\w+(\\s\\w+)*)*"
    in
        [ Forms.validateExistence
        , validateRegularExpression answersRegex
        ]


subjectValidations : List Forms.FieldValidator
subjectValidations =
    [ Forms.validateExistence ]


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
