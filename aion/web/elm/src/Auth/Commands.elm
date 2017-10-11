module Auth.Commands exposing (..)

import Auth.Models exposing (RegistrationForm, RegistrationResultData)
import Forms
import General.Constants exposing (loginUrl, registerUrl)
import Http
import Json.Decode as Decode exposing (Value)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode
import Msgs exposing (Msg(..))
import RemoteData


authenticate : String -> Decode.Decoder a -> Value -> Http.Request a
authenticate url dec credentials =
    Http.post url (Http.jsonBody credentials) dec


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


registerUser : Forms.Form -> Cmd Msg
registerUser form =
    Http.post registerUrl (registrationDataEncoder form) registrationResultDecoder
        |> RemoteData.sendRequest
        |> Cmd.map RegistrationResult


registrationDataEncoder : RegistrationForm -> Http.Body
registrationDataEncoder form =
    let
        payload =
            [ ( "name", Encode.string (Forms.formValue form "name") )
            , ( "email", Encode.string (Forms.formValue form "email") )
            , ( "password", Encode.string (Forms.formValue form "password") )
            ]
    in
        payload
            |> Encode.object
            |> Http.jsonBody


registrationResultDecoder : Decode.Decoder RegistrationResultData
registrationResultDecoder =
    decode RegistrationResultData
        |> required "name" Decode.string
        |> required "id" Decode.int
        |> required "email" Decode.string
