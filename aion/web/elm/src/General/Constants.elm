module General.Constants exposing (..)

import Navigation exposing (Location)
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


loginFormMsg : String
loginFormMsg =
    "Don't have an account? Click here to register"


registerFormMsg : String
registerFormMsg =
    "Already have an account? Click here to login"


roomsPath : String
roomsPath =
    "#rooms"


panelPath : String
panelPath =
    "#panel"


userPath : String
userPath =
    "#profile"


type alias SimpleCardConfig =
    { svgImage : String
    , title : String
    , description : String
    , url : String
    , buttonText : String
    }
