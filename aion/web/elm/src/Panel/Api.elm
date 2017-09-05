module Panel.Api exposing (..)

import Forms
import General.Constants exposing (createCategoryUrl, createQuestionUrl)
import Http
import Msgs exposing (Msg)
import Navigation exposing (Location)
import RemoteData exposing (WebData)
import Panel.Decoders exposing (categoryCreatedDecoder, questionCreatedDecoder)
import Json.Encode as Encode
import Panel.Models exposing (CategoryForm, QuestionForm)
import Room.Models exposing (RoomsData)


-- create question section


createQuestionWithAnswers : Location -> QuestionForm -> WebData RoomsData -> Cmd Msg
createQuestionWithAnswers location form rooms =
    Http.post (createQuestionUrl location) (questionCreationEncoder form rooms) questionCreatedDecoder
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


createCategory : Location -> CategoryForm -> Cmd Msg
createCategory location form =
    Http.post (createCategoryUrl location) (categoryCreationEncoder form) categoryCreatedDecoder
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
