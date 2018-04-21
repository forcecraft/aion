module Room.Decoders exposing (..)

import Lobby.Models exposing (Room)
import Room.Models exposing (Answer, AnswerFeedback, CurrentQuestion, QuestionSummary, UserJoinedInfo, UserLeft, UserList, UserListMessage, UserRecord)
import Json.Decode as Decode exposing (field, list, map, null, oneOf)
import Json.Decode.Pipeline exposing (decode, required)


userListMessageDecoder : Decode.Decoder UserListMessage
userListMessageDecoder =
    Decode.map UserListMessage
        (field "users" (Decode.list userRecordDecoder))


userRecordDecoder : Decode.Decoder UserRecord
userRecordDecoder =
    Decode.map3 UserRecord
        (field "username" Decode.string)
        (field "score" Decode.int)
        (field "questions_asked" Decode.int)


questionDecoder : Decode.Decoder CurrentQuestion
questionDecoder =
    Decode.map2 CurrentQuestion
        (field "content" Decode.string)
        (field "image_name" Decode.string)


answerFeedbackDecoder : Decode.Decoder AnswerFeedback
answerFeedbackDecoder =
    Decode.map AnswerFeedback (field "feedback" Decode.string)


userJoinedInfoDecoder : Decode.Decoder UserJoinedInfo
userJoinedInfoDecoder =
    Decode.map UserJoinedInfo (field "user" Decode.string)


userLeftDecoder : Decode.Decoder UserLeft
userLeftDecoder =
    Decode.map UserLeft (field "user" Decode.string)


questionSummaryDecoder : Decode.Decoder QuestionSummary
questionSummaryDecoder =
    decode QuestionSummary
        |> required "winner" Decode.string
        |> required "answers" (Decode.list answerDecoder)


answerDecoder : Decode.Decoder Answer
answerDecoder =
    Decode.string
