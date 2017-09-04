module Panel.Api exposing (..)

import Forms
import General.Constants exposing (createCategoryUrl, createQuestionUrl, hostname, createRoomUrl)
import Http
import Msgs exposing (Msg)
import RemoteData exposing (WebData)
import Panel.Decoders exposing (categoryCreatedDecoder, questionCreatedDecoder, roomCreatedDecoder)
import Json.Encode as Encode
import Panel.Models exposing (CategoryForm, QuestionForm, RoomForm)
import Room.Models exposing (RoomsData)


-- create question section


createQuestionWithAnswers : QuestionForm -> WebData RoomsData -> Cmd Msg
createQuestionWithAnswers form rooms =
    Http.post createQuestionUrl (questionCreationEncoder form rooms) questionCreatedDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnQuestionCreated


questionCreationEncoder : QuestionForm -> WebData RoomsData -> Http.Body
questionCreationEncoder form rooms =
    let
        questionValue =
            Forms.formValue form "question"

        answersValue =
            Forms.formValue form "answers"

        subjectValue =
            Forms.formValue form "subject"

        questionContent =
            [ ( "content", Encode.string questionValue )
            ]

        payload =
            [ ( "question", Encode.object questionContent )
            , ( "answers", Encode.string answersValue )
            , ( "subject", Encode.int (String.toInt subjectValue |> Result.toMaybe |> Maybe.withDefault 0) )
            ]
    in
        payload
            |> Encode.object
            |> Http.jsonBody



-- create category section


createCategory : CategoryForm -> Cmd Msg
createCategory form =
    Http.post createCategoryUrl (categoryCreationEncoder form) categoryCreatedDecoder
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
            [ ( "subject", Encode.object questionContent ) ]
    in
        payload
            |> Encode.object
            |> Http.jsonBody


createRoom : RoomForm -> List (String) -> Cmd Msg
createRoom form subjectIds =
    Http.post createRoomUrl (roomCreationEncoder form subjectIds) roomCreatedDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnRoomCreated


roomCreationEncoder : RoomForm -> List (String) -> Http.Body
roomCreationEncoder form subjectIds =
    let
        roomName =
            Forms.formValue form "name"

        roomDescription =
            Forms.formValue form "description"

        subjectIdsValues = List.map Encode.string subjectIds

        roomContent =
            [ ( "name", Encode.string roomName )
            , ( "description", Encode.string roomDescription )
            , ( "subject_ids", Encode.list subjectIdsValues ) ]

        payload =
            [ ( "room", Encode.object roomContent ) ]
    in
        payload
            |> Encode.object
            |> Http.jsonBody