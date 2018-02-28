module User.Api exposing (..)

import Http exposing (Error(BadStatus))
import Http exposing (Request)
import Json.Decode as Decode
import Navigation exposing (Location)
import RemoteData
import Urls exposing (host, userScoresUrl)
import User.Decoders exposing (userDecoder, userScoresDecoder)
import User.Models exposing (CurrentUser, UserScores)
import Auth.Models exposing (Token)
import User.Msgs exposing (UserMsg(OnFetchCurrentUser, OnFetchUserScores))


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


fetchCurrentUser : Location -> String -> Cmd UserMsg
fetchCurrentUser location token =
    let
        url =
            fetchCurrentUserUrl location
    in
        fetchCurrentUserRequest url token userDecoder
            |> RemoteData.sendRequest
            |> Cmd.map OnFetchCurrentUser


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


fetchUserScores : Location -> Token -> Cmd UserMsg
fetchUserScores location token =
    let
        url =
            userScoresUrl location
    in
        fetchUserScoresRequest url token userScoresDecoder
            |> RemoteData.sendRequest
            |> Cmd.map OnFetchUserScores


unauthorized : UserMsg -> Bool
unauthorized msg =
    case msg of
        OnFetchCurrentUser (RemoteData.Failure (BadStatus response)) ->
            response.status.code == unauthorizedCode

        OnFetchUserScores (RemoteData.Failure (BadStatus response)) ->
            response.status.code == unauthorizedCode

        _ ->
            False


unauthorizedCode : Int
unauthorizedCode =
    401
