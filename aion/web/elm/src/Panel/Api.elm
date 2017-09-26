module Panel.Api exposing (..)

import Forms
import General.Constants exposing ()
import Http
import Msgs exposing (Msg)
import Navigation exposing (Location)
import RemoteData exposing (WebData)
import Panel.Decoders exposing (categoriesDecoder, categoryCreatedDecoder, questionCreatedDecoder, roomCreatedDecoder)
import Json.Encode as Encode
import Panel.Models exposing (CategoryForm, QuestionForm, RoomForm)
import Room.Models exposing (RoomsData)
import Urls exposing (categoriesUrl, questionsUrl, hostname, roomsUrl)


-- create question section


createQuestionWithAnswers : Location -> QuestionForm -> WebData RoomsData -> Cmd Msg
createQuestionWithAnswers location form rooms =
    Http.post (questionsUrl location) (questionCreationEncoder form rooms) questionCreatedDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnQuestionCreated


questionCreationEncoder : QuestionForm -> WebData RoomsData -> Http.Body
questionCreationEncoder form rooms =
    let
        questionValue =
            Forms.formValue form "question"

        answersValue =
            Forms.formValue form "answers"

        categoryValue =
            Forms.formValue form "category"

        questionContent =
            [ ( "content", Encode.string questionValue )
            ]

        payload =
            [ ( "question", Encode.object questionContent )
            , ( "answers", Encode.string answersValue )
            , ( "category", Encode.int (String.toInt categoryValue |> Result.toMaybe |> Maybe.withDefault 0) )
            ]
    in
        payload
            |> Encode.object
            |> Http.jsonBody



-- create category section


createCategory : Location -> CategoryForm -> Cmd Msg
createCategory location form =
    Http.post (categoriesUrl location) (categoryCreationEncoder form) categoryCreatedDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnCategoryCreated


categoryCreationEncoder : QuestionForm -> Http.Body
categoryCreationEncoder form =
    let
        categoryName =
            Forms.formValue form "name"

        questionContent =
            [ ( "name", Encode.string categoryName ) ]

        payload =
            [ ( "category", Encode.object questionContent ) ]
    in
        payload
            |> Encode.object
            |> Http.jsonBody



-- list categories section


fetchCategories : Cmd Msg
fetchCategories =
    Http.get categoriesUrl categoriesDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchCategories


createRoom : RoomForm -> List String -> Cmd Msg
createRoom form categoryIds =
    Http.post roomsUrl (roomCreationEncoder form categoryIds) roomCreatedDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnRoomCreated



-- room creation section


roomCreationEncoder : RoomForm -> List String -> Http.Body
roomCreationEncoder form categoryIds =
    let
        roomName =
            Forms.formValue form "name"

        roomDescription =
            Forms.formValue form "description"

        categoryIdsValues =
            List.map Encode.string categoryIds

        roomContent =
            [ ( "name", Encode.string roomName )
            , ( "description", Encode.string roomDescription )
            , ( "category_ids", Encode.list categoryIdsValues )
            ]

        payload =
            [ ( "room", Encode.object roomContent ) ]
    in
        payload
            |> Encode.object
            |> Http.jsonBody
