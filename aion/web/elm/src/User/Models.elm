module User.Models exposing (..)

import RemoteData exposing (WebData)


type alias UserData =
    { details : WebData CurrentUser
    , scores : WebData UserScores
    }


initUserData : UserData
initUserData =
    { details = RemoteData.Loading
    , scores = RemoteData.Loading
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
