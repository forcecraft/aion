module User.Api exposing (..)

import Http
import Msgs exposing (Msg)
import Navigation exposing (Location)
import RemoteData
import Urls exposing (host)
import User.Decoders exposing (userDecoder)


fetchCurrentUserUrl : Location -> String
fetchCurrentUserUrl location =
    (host location) ++ "api/me"


fetchCurrentUser : Location -> Cmd Msg
fetchCurrentUser location =
    Http.get (fetchCurrentUserUrl location) userDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchCurrentUser
