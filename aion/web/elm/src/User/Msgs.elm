module User.Msgs exposing (..)

import RemoteData exposing (WebData)
import User.Models exposing (CurrentUser, UserScores)


type UserMsg
    = OnFetchCurrentUser (WebData CurrentUser)
    | OnFetchUserScores (WebData UserScores)
