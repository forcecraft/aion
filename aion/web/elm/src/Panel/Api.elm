module Panel.Api exposing (..)

import Forms
import General.Constants exposing (hostname)
import General.Models exposing (Model)
import General.Utils exposing (getSubjectIdByName)
import Http
import Msgs exposing (Msg)
import RemoteData
import Panel.Decoders exposing (questionCreatedDecoder)
import Json.Encode as Encode


createQuestionUrl : String
createQuestionUrl =
    hostname ++ "api/questions"


createQuestionWithAnswers : Model -> Cmd Msg
createQuestionWithAnswers model =
    Http.post createQuestionUrl (questionCreationEncoder model) questionCreatedDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnQuestionCreated


questionCreationEncoder : Model -> Http.Body
questionCreationEncoder model =
    let
        form =
            model.panelData.createQuestionForm

        questionValue =
            Forms.formValue form "question"

        answersValue =
            Forms.formValue form "answers"

        subjectValue =
            Forms.formValue form "subject"

        subjectId =
            getSubjectIdByName model.rooms subjectValue

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
