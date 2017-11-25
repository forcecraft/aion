module User.Api exposing (..)

import Http
import Http exposing (Request)
import Json.Decode as Decode
import Msgs exposing (Msg)
import Navigation exposing (Location)
import RemoteData
import Urls exposing (host, userScoresUrl)
import User.Decoders exposing (userDecoder, userScoresDecoder)
import User.Models exposing (CurrentUser, UserScores)
import Auth.Models exposing (Token)


fetchCurrentUserUrl : Location -> String
fetchCurrentUserUrl location =
    (host location) ++ "api/me"


fetchCurrentUserRequest : String -> String -> Decode.Decoder CurrentUser -> Request CurrentUser
fetchCurrentUserRequest url token decoder =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ token) ]
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = True
        }


fetchCurrentUser : Location -> String -> Cmd Msg
fetchCurrentUser location token =
    let
        url =
            fetchCurrentUserUrl location
    in
        fetchCurrentUserRequest url token userDecoder
            |> RemoteData.sendRequest
            |> Cmd.map Msgs.OnFetchCurrentUser


fetchUserScoresRequest : String -> String -> Decode.Decoder UserScores -> Request UserScores
fetchUserScoresRequest url token decoder =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ token) ]
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = True
        }


fetchUserScores : Location -> Token -> Cmd Msg
fetchUserScores location token =
    let
        url =
            userScoresUrl location
    in
        fetchUserScoresRequest url token userScoresDecoder
            |> RemoteData.sendRequest
            |> Cmd.map Msgs.OnFetchUserScores
