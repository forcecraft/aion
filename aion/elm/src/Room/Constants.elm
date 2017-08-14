module Room.Constants exposing (..)

import General.Constants exposing (hostname)


enterKeyCode : Int
enterKeyCode =
    13


imagesPath : String
imagesPath =
    hostname ++ "images/"


defaultImagePath : String
defaultImagePath =
    imagesPath ++ "question-mark.jpg"
