module User.Models exposing (..)

import Navigation exposing (Location)
import RemoteData exposing (WebData)
import Urls exposing (Url, host)


type alias UserData =
    { details : WebData CurrentUser
    , scores : WebData UserScores
    , urls : ContextUrls
    }


initUserData : Location -> UserData
initUserData location =
    { details = RemoteData.Loading
    , scores = RemoteData.Loading
    , urls = initContextUrls location
    }


type alias ContextUrls =
    { avatarPlaceholder : Url
    }


initContextUrls location =
    { avatarPlaceholder = (host location) ++ "placeholders/avatar_placeholder.png"
    }


type alias CurrentUser =
    { name : String
    , id : Int
    , email : String
    }


type alias UserScores =
    { categoryScores : List UserCategoryScore }


type alias UserCategoryScore =
    { categoryName : String
    , score : Int
    }
