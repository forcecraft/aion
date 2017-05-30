module General.View exposing (..)

import General.Models exposing (Model)
import Html exposing (Html, a, div, i, text)
import Html.Attributes exposing (href)
import Msgs exposing (Msg)
import Routing exposing (roomsPath)


notFoundView : Html Msg
notFoundView =
    div []
        [ text "Not found"
        ]


homeView : Model -> Html Msg
homeView model =
    div []
        [ p [] [ text "Welcome to Aion!" ]
        , roomListButton
        ]


roomListButton : Html Msg
roomListButton =
    let
        path =
            roomsPath
    in
        a
            [ href path ]
            [ i [] []
            , text "Rooms"
            ]
