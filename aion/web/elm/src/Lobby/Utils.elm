module General.Utils exposing (..)

import Array exposing (Array, fromList)
import Html exposing (Html, text)
import Lobby.Msgs exposing (LobbyMsg)
import RemoteData exposing (WebData)


sliceList : Int -> List a -> List (List a)
sliceList n list =
    case ( n, list ) of
        ( 0, list ) ->
            [ list ]

        ( n, [] ) ->
            []

        ( n, list ) ->
            (List.take n list) :: (sliceList n (List.drop n list))


displayWebData : WebData a -> (a -> Html LobbyMsg) -> Html LobbyMsg
displayWebData webData fun =
    case webData of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success data ->
            fun data

        RemoteData.Failure error ->
            text (toString error)
