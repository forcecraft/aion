module Room.Urls exposing (..)

import Navigation exposing (Location)
import Room.Constants exposing (defaultImagePath, imagesPath)


getImageUrl : Location -> String -> String
getImageUrl location imageName =
    case imageName of
        "" ->
            defaultImagePath location

        _ ->
            (imagesPath location) ++ imageName
