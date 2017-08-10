module User.Decoders exposing (..)

import User.Models exposing (CurrentUser)
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)


userDecoder : Decode.Decoder CurrentUser
userDecoder =
    decode CurrentUser
        |> required "name" Decode.string
        |> required "id" Decode.int
        |> required "email" Decode.string
