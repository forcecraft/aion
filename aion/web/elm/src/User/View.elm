module User.View exposing (..)

import Bootstrap.Alert as Alert
import Bootstrap.Button as Button
import General.Models exposing (Model)
import Html exposing (..)
import Html.Attributes exposing (class)
import Msgs exposing (Msg(..))
import RemoteData
import User.Models exposing (CurrentUser)


userView : Model -> Html Msg
userView model =
    case model.user of
        RemoteData.Success user ->
            renderUserView user

        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Failure error ->
            text (toString error)


renderUserView : CurrentUser -> Html Msg
renderUserView user =
    div [ class "profile-container" ]
        [ Alert.success [ text ("username: " ++ user.name) ]
        , Alert.success [ text ("e-mail: " ++ user.email) ]
        , Button.button
            [ Button.outlineDanger
            , Button.onClick Logout
            ]
            [ text "Logout" ]
        ]
