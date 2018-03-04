module User.Update exposing (..)

import General.Models exposing (Model)
import Ports exposing (check)
import User.Msgs exposing (UserMsg(Logout, OnFetchCurrentUser, OnFetchUserScores))


update : UserMsg -> Model -> ( Model, Cmd UserMsg )
update msg model =
    case msg of
        OnFetchCurrentUser response ->
            let
                oldUserData =
                    model.user
            in
                { model | user = { oldUserData | details = response } } ! []

        OnFetchUserScores response ->
            let
                oldUserData =
                    model.user
            in
                { model | user = { oldUserData | scores = response } } ! []

        Logout ->
            let
                oldAuthData =
                    model.authData
            in
                { model | authData = { oldAuthData | token = Nothing } } ! [ check "" ]
