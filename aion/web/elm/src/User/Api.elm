module User.Api exposing (..)

import General.Constants exposing (currentUserUrl, hostname)
import Http exposing (Request)
import Json.Decode as Decode
import Msgs exposing (Msg)
import RemoteData
import User.Decoders exposing (userDecoder)
import User.Models exposing (CurrentUser)


fetchCurrentUserRequest : String -> Decode.Decoder CurrentUser -> Request CurrentUser
fetchCurrentUserRequest token decoder =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ token) ]
        , url = currentUserUrl
        , body = Http.emptyBody
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = True
        }


fetchCurrentUser : String -> Cmd Msg
fetchCurrentUser token =
    fetchCurrentUserRequest token userDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchCurrentUser
