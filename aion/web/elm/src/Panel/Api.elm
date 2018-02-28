module Panel.Api exposing (..)

import Forms
import Http exposing (Body, Error(BadStatus), Request)
import Json.Decode as Decode
import Navigation exposing (Location)
import Panel.Msgs exposing (PanelMsg(OnCategoryCreated, OnFetchCategories, OnQuestionCreated, OnRoomCreated))
import RemoteData exposing (WebData)
import Panel.Decoders exposing (categoriesDecoder, categoryCreatedDecoder, questionCreatedDecoder, roomCreatedDecoder)
import Json.Encode as Encode
import Panel.Models exposing (CategoriesData, CategoryCreatedData, CategoryForm, QuestionCreatedData, QuestionForm, RoomCreatedData, RoomForm)
import Room.Models exposing (RoomsData)
import Urls exposing (categoriesUrl, questionsUrl, hostname, roomsUrl)


-- list categories section


fetchCategoriesRequest : String -> String -> Decode.Decoder CategoriesData -> Request CategoriesData
fetchCategoriesRequest url token decoder =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ token) ]
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = True
        }


fetchCategories : Location -> String -> Cmd PanelMsg
fetchCategories location token =
    let
        url =
            categoriesUrl location
    in
        fetchCategoriesRequest url token categoriesDecoder
            |> RemoteData.sendRequest
            |> Cmd.map OnFetchCategories



-- create question section


createQuestionWithAnswersRequest : String -> String -> Decode.Decoder QuestionCreatedData -> Body -> Request QuestionCreatedData
createQuestionWithAnswersRequest url token decoder body =
    Http.request
        { method = "POST"
        , headers = [ Http.header "Authorization" ("Bearer " ++ token) ]
        , url = url
        , body = body
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = True
        }


createQuestionWithAnswers : Location -> String -> QuestionForm -> WebData RoomsData -> Cmd PanelMsg
createQuestionWithAnswers location token form rooms =
    let
        body =
            questionCreationEncoder form rooms

        url =
            questionsUrl location
    in
        createQuestionWithAnswersRequest url token questionCreatedDecoder body
            |> RemoteData.sendRequest
            |> Cmd.map OnQuestionCreated


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


createCategoryRequest : String -> String -> Decode.Decoder CategoryCreatedData -> Body -> Request CategoryCreatedData
createCategoryRequest url token decoder body =
    Http.request
        { method = "POST"
        , headers = [ Http.header "Authorization" ("Bearer " ++ token) ]
        , url = url
        , body = body
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = True
        }


createCategory : Location -> String -> CategoryForm -> Cmd PanelMsg
createCategory location token form =
    let
        body =
            categoryCreationEncoder form

        url =
            categoriesUrl location
    in
        createCategoryRequest url token categoryCreatedDecoder body
            |> RemoteData.sendRequest
            |> Cmd.map OnCategoryCreated


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


createRoomRequest : String -> String -> Decode.Decoder RoomCreatedData -> Body -> Request RoomCreatedData
createRoomRequest url token decoder body =
    Http.request
        { method = "POST"
        , headers = [ Http.header "Authorization" ("Bearer " ++ token) ]
        , url = url
        , body = body
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = True
        }


createRoom : Location -> String -> RoomForm -> List String -> Cmd PanelMsg
createRoom location token form categoryIds =
    let
        body =
            roomCreationEncoder form categoryIds

        url =
            roomsUrl location
    in
        createRoomRequest url token roomCreatedDecoder body
            |> RemoteData.sendRequest
            |> Cmd.map OnRoomCreated


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


unauthorized : PanelMsg -> Bool
unauthorized msg =
    case msg of
        OnFetchCategories (RemoteData.Failure (BadStatus response)) ->
            response.status.code == 401

        _ ->
            False
