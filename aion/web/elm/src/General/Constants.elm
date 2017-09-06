module General.Constants exposing (..)

import General.Models exposing (SimpleCardConfig)
import Navigation exposing (Location)
import Routing exposing (panelPath, roomsPath, userPath)
import Urls exposing (host)


gameCardConfig : Location -> SimpleCardConfig
gameCardConfig location =
    { svgImage = (host location) ++ "svg/trophy.svg"
    , title = "Play a game"
    , description = "Find a room for yourself and check your knowledge versus other players."
    , url = roomsPath
    , buttonText = "Browse rooms"
    }


panelCardConfig : Location -> SimpleCardConfig
panelCardConfig location =
    { svgImage = (host location) ++ "svg/tasks.svg"
    , title = "Panel"
    , description = "Create new rooms, new categories and new questions."
    , url = panelPath
    , buttonText = "Visit panel"
    }


profileCardConfig : Location -> SimpleCardConfig
profileCardConfig location =
    { svgImage = (host location) ++ "svg/diploma.svg"
    , title = "Profile"
    , description = "Check your profile, gaming history and statistics."
    , url = userPath
    , buttonText = "Go to profile"
    }
