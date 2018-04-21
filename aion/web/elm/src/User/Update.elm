module User.Update exposing (..)

import Ports exposing (check)
import User.Models exposing (UserData)
import User.Msgs exposing (UserMsg(Logout, OnFetchCurrentUser, OnFetchUserScores))


update : UserMsg -> UserData -> ( UserData, Cmd UserMsg )
update msg model =
    case msg of
        OnFetchCurrentUser response ->
            { model | details = response } ! []

        OnFetchUserScores response ->
            { model | scores = response } ! []

        --  this one should be handled in the top-level update in order to clear out the token field
        Logout ->
            model ! []
