module Auth.Api exposing (..)

import Auth.Models exposing (RegistrationForm, RegistrationResultData)
import Auth.Msgs exposing (AuthMsg(LoginResult, RegistrationResult))
import Forms
import Http
import Json.Decode as Decode exposing (Value)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode
import Navigation exposing (Location)
import RemoteData
import Urls exposing (loginUrl, registerUrl)


-- login section


authenticate : String -> Decode.Decoder a -> Value -> Http.Request a
authenticate url decoder credentials =
    Http.post url (Http.jsonBody credentials) decoder


submitCredentials : Location -> Forms.Form -> Cmd AuthMsg
submitCredentials location form =
    let
        payload =
            Encode.object
                [ ( "email", Encode.string (Forms.formValue form "email") )
                , ( "password", Encode.string (Forms.formValue form "password") )
                ]

        url =
            loginUrl location
    in
        payload
            |> authenticate url tokenStringDecoder
            |> Http.send LoginResult


tokenStringDecoder : Decode.Decoder String
tokenStringDecoder =
    Decode.field "token" Decode.string



-- register section


registerUser : Location -> Forms.Form -> Cmd AuthMsg
registerUser location form =
    Http.post (registerUrl location) (registrationDataEncoder form) registrationResultDecoder
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
        |> required "token" Decode.string
