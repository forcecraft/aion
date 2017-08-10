module User.Api exposing (..)

import General.Constants exposing (hostname)
import Http
import Msgs exposing (Msg)
import RemoteData
import User.Decoders exposing (userDecoder)


fetchCurrentUserUrl : String
fetchCurrentUserUrl =
    hostname ++ "api/me"


fetchCurrentUser : Cmd Msg
fetchCurrentUser =
    Http.get fetchCurrentUserUrl userDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchCurrentUser
