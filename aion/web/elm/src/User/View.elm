module User.View exposing (..)

import General.Models exposing (Model)
import Html exposing (..)
import Msgs exposing (Msg(..))
import RemoteData


userView : Model -> Html Msg
userView model =
    case model.user of
        RemoteData.Success user ->
            div []
                [ h3 [] [ text ("Username: " ++ user.name) ]
                , h3 [] [ text ("Email: " ++ user.email) ]
                ]

        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Failure error ->
            text (toString error)
