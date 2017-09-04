module User.Api exposing (..)

import General.Constants exposing (host)
import Http
import Msgs exposing (Msg)
import Navigation exposing (Location)
import RemoteData
import User.Decoders exposing (userDecoder)


fetchCurrentUserUrl : Location -> String
fetchCurrentUserUrl location =
    (host location) ++ "api/me"


fetchCurrentUser : Cmd Msg
fetchCurrentUser =
    Http.get fetchCurrentUserUrl userDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchCurrentUser
