module Room.Decoders exposing (..)

import Room.Models exposing (AnswerFeedback, CurrentQuestion, Room, RoomsData, UserJoinedInfo, UserList, UserListMessage, UserRecord)
import Json.Decode as Decode exposing (field, list, map, null, oneOf)
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
        |> required "description" Decode.string
        |> required "player_count" Decode.int


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
