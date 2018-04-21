module User.View exposing (..)

import Bootstrap.Button as Button
import Html exposing (..)
import Html.Attributes exposing (class, src)
import Navigation exposing (Location)
import RemoteData
import Urls exposing (host)
import User.Models exposing (CurrentUser, UserCategoryScore, UserData)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Badge as Badge
import Bootstrap.Button as Button
import User.Msgs exposing (UserMsg(Logout))


userView : UserData -> Html UserMsg
userView model =
    case model.details of
        RemoteData.Success user ->
            renderUserView model user

        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Failure error ->
            text (toString error)


renderUserView : UserData -> CurrentUser -> Html UserMsg
renderUserView model user =
    div [ class "profile-container" ]
        [ Grid.container []
            [ Grid.row []
                [ Grid.col [] [ (userDetails model user) ] ]
            , Grid.row []
                [ Grid.col [ Col.xs12 ]
                    [ div [ class "userScoreDetails" ]
                        [ h2 [] [ text "Category Scores" ]
                        , p [] [ text "List of your scores per category" ]
                        ]
                    ]
                ]
            , Grid.row [] (displayUserScores model)
            ]
        ]


userDetails : UserData -> CurrentUser -> Html UserMsg
userDetails model user =
    let
        avatarPlaceholder =
            model.urls.avatarPlaceholder
    in
        div []
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


displayUserScores : UserData -> List (Grid.Column UserMsg)
displayUserScores model =
    case model.scores of
        RemoteData.Success userScores ->
            userScores.categoryScores
                |> List.sortBy .score
                |> List.reverse
                |> List.map listSingleScore

        _ ->
            [ Grid.col [] [ text "Loading..." ] ]


listSingleScore : UserCategoryScore -> Grid.Column UserMsg
listSingleScore userCategoryScore =
    Grid.col [ Col.md3, Col.sm4, Col.xs12 ]
        [ div [ class "userScoreBadge" ]
            [ Button.button [ Button.success, Button.small ]
                [ small [] [ (text userCategoryScore.categoryName) ], (Badge.badgeInfo [ class "ml-1" ] [ text (toString userCategoryScore.score) ]) ]
            ]
        ]
