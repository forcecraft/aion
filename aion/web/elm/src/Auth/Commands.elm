module Auth.Commands exposing (..)

import Forms
import General.Constants exposing (loginUrl)
import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Msgs exposing (Msg(..))
import Lib.Jwt exposing (authenticate)


submitCredentials : Forms.Form -> Cmd Msg
submitCredentials form =
    Encode.object
        [ ( "email", Encode.string (Forms.formValue form "email") )
        , ( "password", Encode.string (Forms.formValue form "password") )
        ]
        |> authenticate loginUrl tokenStringDecoder
        |> Http.send LoginResult


tokenStringDecoder : Decode.Decoder String
tokenStringDecoder =
    Decode.field "token" Decode.string
