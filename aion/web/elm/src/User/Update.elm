module General.Update exposing (..)

import General.Models exposing (Model)
import User.Msgs exposing (UserMsg(OnFetchCurrentUser, OnFetchUserScores))


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
