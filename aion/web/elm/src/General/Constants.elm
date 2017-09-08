module General.Constants exposing (..)

import General.Models exposing (SimpleCardConfig)
import Routing exposing (panelPath, roomsPath, userPath)


hostname : String
hostname =
    "http://localhost:4000/"


createCategoryUrl : String
createCategoryUrl =
    hostname ++ "api/categories"


createQuestionUrl : String
createQuestionUrl =
    hostname ++ "api/questions"


fetchRoomsUrl : String
fetchRoomsUrl =
    hostname ++ "api/rooms"


gameCardConfig : SimpleCardConfig
gameCardConfig =
    { svgImage = hostname ++ "svg/trophy.svg"
    , title = "Play a game"
    , description = "Find a room for yourself and check your knowledge versus other players."
    , url = roomsPath
    , buttonText = "Browse rooms"
    }


panelCardConfig : SimpleCardConfig
panelCardConfig =
    { svgImage = hostname ++ "svg/tasks.svg"
    , title = "Panel"
    , description = "Create new rooms, new categories and new questions."
    , url = panelPath
    , buttonText = "Visit panel"
    }


profileCardConfig : SimpleCardConfig
profileCardConfig =
    { svgImage = hostname ++ "svg/diploma.svg"
    , title = "Profile"
    , description = "Check your profile, gaming history and statistics."
    , url = userPath
    , buttonText = "Go to profile"
    }
