module User.View exposing (..)

import Bootstrap.Alert as Alert
import General.Models exposing (Model)
import Html exposing (..)
import Html.Attributes exposing (style)
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
    div [ style [ ( "padding", "60px 30px 0px 30px" ) ] ]
        [ Alert.info [ text ("username: " ++ user.name) ]
        , Alert.info [ text ("e-mail: " ++ user.email) ]
        ]
