module Panel.Decoders exposing (..)

import Json.Decode as Decode exposing (field, map, null, oneOf)
import Json.Decode.Pipeline exposing (decode, required)
import Panel.Models exposing (CategoryCreatedContent, CategoryCreatedData, QuestionCreatedContent, QuestionCreatedData)


-- question creation section


questionCreatedDecoder : Decode.Decoder QuestionCreatedData
questionCreatedDecoder =
    decode QuestionCreatedData
        |> required "data" questionCreatedContentDecoder


questionCreatedContentDecoder : Decode.Decoder QuestionCreatedContent
questionCreatedContentDecoder =
    decode QuestionCreatedContent
        |> required "category_id" Decode.int
        |> required "image_name" (oneOf [ Decode.string, null "" ])
        |> required "id" Decode.int
        |> required "content" Decode.string



-- category creation section


categoryCreatedDecoder : Decode.Decoder CategoryCreatedData
categoryCreatedDecoder =
    decode CategoryCreatedData
        |> required "data" categoryCreatedContendDecoder


categoryCreatedContendDecoder : Decode.Decoder CategoryCreatedContent
categoryCreatedContendDecoder =
    decode CategoryCreatedContent
        |> required "id" Decode.int
        |> required "name" Decode.string
