module Panel.Api exposing (..)

import Forms
import General.Constants exposing (categoriesUrl, questionsUrl, hostname)
import Http
import Msgs exposing (Msg)
import RemoteData exposing (WebData)
import Panel.Decoders exposing (categoriesDecoder, categoryCreatedDecoder, questionCreatedDecoder)
import Json.Encode as Encode
import Panel.Models exposing (CategoryForm, QuestionForm)
import Room.Models exposing (RoomsData)


-- create question section


createQuestionWithAnswers : QuestionForm -> WebData RoomsData -> Cmd Msg
createQuestionWithAnswers form rooms =
    Http.post questionsUrl (questionCreationEncoder form rooms) questionCreatedDecoder
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


createCategory : CategoryForm -> Cmd Msg
createCategory form =
    Http.post categoriesUrl (categoryCreationEncoder form) categoryCreatedDecoder
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
