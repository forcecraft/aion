module Room.Decoders exposing (..)

import Room.Models exposing (AnswerFeedback, QuestionInRoom, Room, RoomsData, UserInRoomRecord, UserList)
import Json.Decode as Decode exposing (field, map, null, oneOf)
import Json.Decode.Pipeline exposing (decode, required)


roomsDecoder : Decode.Decoder RoomsData
roomsDecoder =
    decode RoomsData
        |> required "data" (Decode.list (roomDecoder))


roomDecoder : Decode.Decoder Room
roomDecoder =
    decode Room
        |> required "id" Decode.int
        |> required "name" Decode.string


usersListDecoder : Decode.Decoder UserList
usersListDecoder =
    Decode.map UserList
        (field "users" (Decode.list userRecordDecoder))


userRecordDecoder : Decode.Decoder UserInRoomRecord
userRecordDecoder =
    Decode.map2 UserInRoomRecord
        (field "username" Decode.string)
        (field "score" Decode.int)


questionDecoder : Decode.Decoder QuestionInRoom
questionDecoder =
    Decode.map2 QuestionInRoom
        (field "content" Decode.string)
        (field "image_name" Decode.string)


answerFeedbackDecoder : Decode.Decoder AnswerFeedback
answerFeedbackDecoder =
    Decode.map AnswerFeedback (field "feedback" Decode.string)
