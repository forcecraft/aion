module Room.Constants exposing (..)

import Navigation exposing (Location)
import Urls exposing (host)


enterKeyCode : Int
enterKeyCode =
    13


imagesPath : Location -> String
imagesPath location =
    (host location) ++ "images/"


defaultImagePath : Location -> String
defaultImagePath location =
    (imagesPath location) ++ "question-mark.jpg"


answerInputFieldId : String
answerInputFieldId =
    "answerInputField"



-- all timeouts are in milliseconds


progressBarTimeout : Float
progressBarTimeout =
    10000
