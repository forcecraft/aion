module Panel.Api exposing (..)

import Http
import Msgs exposing (Msg)
import RemoteData
import Panel.Decoders exposing (questionCreatedDecoder)
import Panel.Models exposing (PanelData)
import Json.Encode as Encode


createQuestionUrl : String
createQuestionUrl =
    "http://localhost:4000/api/questions"


createQuestionWithAnswers : PanelData -> Cmd Msg
createQuestionWithAnswers panelData =
    Http.post createQuestionUrl (questionCreationEncoder panelData) questionCreatedDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnQuestionCreated


questionCreationEncoder : PanelData -> Http.Body
questionCreationEncoder panelData =
    let
        questionContent =
            [ ( "content", Encode.string panelData.newQuestionContent )
            , ( "subject", Encode.int panelData.newAnswerCategory )
            ]

        payload =
            [ ( "question", Encode.object questionContent )
            , ( "answers", Encode.string panelData.newAnswerContent )
            ]
    in
        payload
            |> Encode.object
            |> Http.jsonBody
