module User.Api exposing (..)

import General.Constants exposing (currentUserUrl, hostname)
import Http exposing (Request)
import Json.Decode as Decode
import Msgs exposing (Msg)
import RemoteData
import User.Decoders exposing (userDecoder)
import User.Models exposing (CurrentUser)


getCurrentUserRequest : Decode.Decoder CurrentUser -> Request CurrentUser
getCurrentUserRequest decoder =
    Http.request
    { method = "GET"
    , headers = [ Http.header "Authorization" "Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJVc2VyOjYiLCJleHAiOjE1MTAyOTg0NDcsImlhdCI6MTUwNzcwNjQ0NywiaXNzIjoiQWlvbiIsImp0aSI6ImQwNTY4OTJjLTVmNDgtNGVlYS05YjVhLTQ2NzBlYmM4OWYxOSIsInBlbSI6e30sInN1YiI6IlVzZXI6NiIsInR5cCI6ImFjY2VzcyJ9.zEl19eW2v7mqL5x5PzKInp5HBMvzhe2E2czLufpIDc7RRjv1JUZE21OuXxynIMjf6mTMScvCJduprBHuD2JTAg"]
    , url = currentUserUrl
    , body = Http.emptyBody
    , expect = Http.expectJson decoder
    , timeout = Nothing
    , withCredentials = False
    }

fetchCurrentUser : Cmd Msg
fetchCurrentUser =
    getCurrentUserRequest userDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchCurrentUser
