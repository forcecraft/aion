module Room.Decoders exposing (..)

import Json.Decode.Pipeline exposing (decode, required)
import Room.Models exposing (Room, RoomsData, UserInRoomRecord, UserList)
import Json.Decode as Decode exposing (field)


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
        (field "name" Decode.string)
        (field "score" Decode.int)
