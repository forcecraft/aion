module Panel.Api exposing (..)

import Http
import Msgs exposing (Msg)
import RemoteData
import Panel.Decoders exposing (questionCreatedDecoder)
import Panel.Models exposing (PanelData)


createQuestionUrl : String
createQuestionUrl =
    "http://localhost:4000/api/questions"


createQuestionWithAnswers : PanelData -> Cmd Msg
createQuestionWithAnswers panelData =
    Http.post createQuestionUrl Http.emptyBody questionCreatedDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnQuestionCreated
