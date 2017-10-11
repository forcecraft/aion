module Panel.Api exposing (..)

import Forms
import General.Constants exposing (categoriesUrl, questionsUrl, hostname, roomsUrl)
import Http exposing (Body, Request)
import Json.Decode as Decode
import Msgs exposing (Msg)
import RemoteData exposing (WebData)
import Panel.Decoders exposing (categoriesDecoder, categoryCreatedDecoder, questionCreatedDecoder, roomCreatedDecoder)
import Json.Encode as Encode
import Panel.Models exposing (CategoriesData, CategoryCreatedData, CategoryForm, QuestionCreatedData, QuestionForm, RoomCreatedData, RoomForm)
import Room.Models exposing (RoomsData)


-- list categories section


fetchCategoriesRequest : String -> Decode.Decoder CategoriesData -> Request CategoriesData
fetchCategoriesRequest token decoder =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ token) ]
        , url = categoriesUrl
        , body = Http.emptyBody
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = True
        }


fetchCategories : String -> Cmd Msg
fetchCategories token =
    fetchCategoriesRequest token categoriesDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchCategories



-- create question section


createQuestionWithAnswersRequest : String -> Decode.Decoder QuestionCreatedData -> Body -> Request QuestionCreatedData
createQuestionWithAnswersRequest token decoder body =
    Http.request
        { method = "POST"
        , headers = [ Http.header "Authorization" ("Bearer " ++ token) ]
        , url = questionsUrl
        , body = body
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = True
        }


createQuestionWithAnswers : String -> QuestionForm -> WebData RoomsData -> Cmd Msg
createQuestionWithAnswers token form rooms =
    let
        body =
            questionCreationEncoder form rooms
    in
        createQuestionWithAnswersRequest token questionCreatedDecoder body
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


createCategoryRequest : String -> Decode.Decoder CategoryCreatedData -> Body -> Request CategoryCreatedData
createCategoryRequest token decoder body =
    Http.request
        { method = "POST"
        , headers = [ Http.header "Authorization" ("Bearer " ++ token) ]
        , url = categoriesUrl
        , body = body
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = True
        }


createCategory : String -> CategoryForm -> Cmd Msg
createCategory token form =
    let
        body =
            categoryCreationEncoder form
    in
        createCategoryRequest token categoryCreatedDecoder body
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



-- room creation section


createRoomRequest : String -> Decode.Decoder RoomCreatedData -> Body -> Request RoomCreatedData
createRoomRequest token decoder body =
    Http.request
        { method = "POST"
        , headers = [ Http.header "Authorization" ("Bearer " ++ token) ]
        , url = roomsUrl
        , body = body
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = True
        }


createRoom : String -> RoomForm -> List String -> Cmd Msg
createRoom token form categoryIds =
    let
        body =
            roomCreationEncoder form categoryIds
    in
        createRoomRequest token roomCreatedDecoder body
            |> RemoteData.sendRequest
            |> Cmd.map Msgs.OnRoomCreated


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
