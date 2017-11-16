module User.View exposing (..)

import Bootstrap.Alert as Alert
import Bootstrap.Button as Button
import General.Models exposing (Model)
import Html exposing (..)
import Html.Attributes exposing (class, src)
import Msgs exposing (Msg(..))
import Navigation exposing (Location)
import RemoteData
import Urls exposing (host)
import User.Models exposing (CurrentUser)


userView : Model -> Html Msg
userView model =
    case model.user of
        RemoteData.Success user ->
            renderUserView model.location user

        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Failure error ->
            text (toString error)


renderUserView : Location -> CurrentUser -> Html Msg
renderUserView location user =
    let
        avatarPlaceholder =
            (host location) ++ "placeholders/avatar_placeholder.png"
    in
        div [ class "profile-container" ]
            [ img [ src avatarPlaceholder, class "user-avatar" ] []
            , div [ class "user-info-block" ]
                [ p [ class "user-name" ] [ text user.name ]
                , p [ class "user-email" ] [ text user.email ]
                , Button.button
                    [ Button.attrs [ class "user-logut" ]
                    , Button.outlineDanger
                    , Button.onClick Logout
                    ]
                    [ text "Logout" ]
                ]
            ]
