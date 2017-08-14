module Panel.Decoders exposing (..)

import Json.Decode as Decode exposing (field, map, null, oneOf)
import Json.Decode.Pipeline exposing (decode, required)
import Panel.Models exposing (QuestionCreatedContent, QuestionCreatedData)


questionCreatedDecoder : Decode.Decoder QuestionCreatedData
questionCreatedDecoder =
    decode QuestionCreatedData
        |> required "data" questionCreatedContentDecoder


questionCreatedContentDecoder : Decode.Decoder QuestionCreatedContent
questionCreatedContentDecoder =
    decode QuestionCreatedContent
        |> required "subject_id" Decode.int
        |> required "image_name" (oneOf [ Decode.string, null "" ])
        |> required "id" Decode.int
        |> required "content" Decode.string
