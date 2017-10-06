module Lib.Jwt.Decoders exposing (JwtToken, firebase)

{-| Helper functions for working with Jwt tokens and authenticated CRUD APIs.

This package provides functions for reading tokens, and for using them to make
authenticated Http requests.


# Decoders for popular Jwt tokens

@docs JwtToken, firebase

-}

import Json.Decode as Json exposing (Decoder, Value, field)


{-| Generic constructor for commonly found fields in a Jwt token
-}
type alias JwtToken =
    { iat : Int
    , exp : Int
    , userId : Maybe String
    , email : Maybe String
    }


andMap : Decoder a -> Decoder (a -> b) -> Decoder b
andMap =
    Json.map2 (|>)


{-| Decoder for Firebase Jwt
-}
firebase : Decoder JwtToken
firebase =
    Json.succeed JwtToken
        |> andMap (field "iat" Json.int)
        |> andMap (field "exp" Json.int)
        |> andMap (Json.maybe <| field "user_id" Json.string)
        |> andMap (Json.maybe <| field "email" Json.string)


phoenixGuardian : Decoder JwtToken
phoenixGuardian =
    Json.succeed JwtToken
        |> andMap (field "iat" Json.int)
        |> andMap (field "exp" Json.int)
        |> andMap (Json.succeed Nothing)
        |> andMap (Json.succeed Nothing)
