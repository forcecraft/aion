module General.Update exposing (..)

import General.Models exposing (Model)
import Msgs exposing (Msg(OnFetchCurrentUser, OnFetchUserScores))


update : Msg -> Model -> ( Model, Cmd Msg )
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
