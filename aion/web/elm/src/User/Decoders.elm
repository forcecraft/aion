module User.Decoders exposing (..)

import User.Models exposing (CurrentUser, UserScores, UserCategoryScore)
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)


userDecoder : Decode.Decoder CurrentUser
userDecoder =
    decode CurrentUser
        |> required "name" Decode.string
        |> required "id" Decode.int
        |> required "email" Decode.string


userScoresDecoder : Decode.Decoder UserScores
userScoresDecoder =
    decode UserScores
        |> required "categoryScores" (Decode.list (userCategoryScoreDecoder))


userCategoryScoreDecoder : Decode.Decoder UserCategoryScore
userCategoryScoreDecoder =
    decode UserCategoryScore
        |> required "categoryName" Decode.string
        |> required "score" Decode.int
