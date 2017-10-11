module General.Constants exposing (..)


hostname : String
hostname =
    "http://localhost:4000/"


categoriesUrl : String
categoriesUrl =
    hostname ++ "api/categories"


questionsUrl : String
questionsUrl =
    hostname ++ "api/questions"


roomsUrl : String
roomsUrl =
    hostname ++ "api/rooms"


loginUrl : String
loginUrl =
    hostname ++ "/sessions"


registerUrl : String
registerUrl =
    hostname ++ "/register"


currentUserUrl : String
currentUserUrl =
    hostname ++ "api/me"


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
