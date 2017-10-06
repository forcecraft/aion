module General.Constants exposing (..)

import General.Models exposing (SimpleCardConfig)
import Navigation exposing (Location)
import Routing exposing (panelPath, roomsPath, userPath)
import Urls exposing (host)


gameCardConfig : Location -> SimpleCardConfig
gameCardConfig location =
    { svgImage = (host location) ++ "svg/trophy.svg"
    , title = "Play!"
    , description = "Find a room matching your interests and compete with others."
    , url = roomsPath
    , buttonText = "Browse rooms"
    }


panelCardConfig : Location -> SimpleCardConfig
panelCardConfig location =
    { svgImage = (host location) ++ "svg/tasks.svg"
    , title = "Workspace"
    , description = "Create new rooms, add new categories and new questions."
    , url = panelPath
    , buttonText = "Visit workspace"
    }


profileCardConfig : Location -> SimpleCardConfig
profileCardConfig location =
    { svgImage = (host location) ++ "svg/diploma.svg"
    , title = "Profile"
    , description = "Check your profile, match history and statistics."
    , url = userPath
    , buttonText = "Go to profile"
    }
