module Room.Constants exposing (..)

import General.Constants exposing (host)
import Navigation exposing (Location)


enterKeyCode : Int
enterKeyCode =
    13


imagesPath : Location -> String
imagesPath location =
    (host location) ++ "images/"


defaultImagePath : String
defaultImagePath =
    imagesPath ++ "question-mark.jpg"


answerInputFieldId : String
answerInputFieldId =
    "answerInputField"
