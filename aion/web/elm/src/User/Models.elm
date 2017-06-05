module User.Models exposing (..)


type alias CurrentUser =
    { name : String
    , id : Int
    , email : String
    }
