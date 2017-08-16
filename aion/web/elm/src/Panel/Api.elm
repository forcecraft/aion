module Panel.Api exposing (..)

import Forms
import General.Constants exposing (hostname)
import General.Utils exposing (getSubjectIdByName)
import Http
import Msgs exposing (Msg)
import RemoteData exposing (WebData)
import Panel.Decoders exposing (questionCreatedDecoder)
import Json.Encode as Encode
import Panel.Models exposing (QuestionForm)
import Room.Models exposing (RoomsData)


createQuestionUrl : String
createQuestionUrl =
    hostname ++ "api/questions"


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

        subjectId =
            getSubjectIdByName rooms subjectValue

        questionContent =
            [ ( "content", Encode.string questionValue )
            ]

        payload =
            [ ( "question", Encode.object questionContent )
            , ( "answers", Encode.string answersValue )
            , ( "subject", Encode.int subjectId )
            ]
    in
        payload
            |> Encode.object
            |> Http.jsonBody
