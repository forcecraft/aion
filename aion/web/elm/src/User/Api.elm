module User.Api exposing (..)

import Http
import Msgs exposing (Msg)
import RemoteData
import User.Decoders exposing (userDecoder)


fetchCurrentUserUrl : String
fetchCurrentUserUrl =
    "http://localhost:4000/api/me"


fetchCurrentUser : Cmd Msg
fetchCurrentUser =
    Http.get fetchCurrentUserUrl userDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchCurrentUser
