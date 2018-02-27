module Socket exposing (..)

import Json.Encode
import Navigation exposing (Location)
import Phoenix.Channel
import Phoenix.Push
import Phoenix.Socket
import Room.Msgs exposing (RoomMsg(ReceiveAnswerFeedback, ReceiveDisplayQuestion, ReceiveQuestion, ReceiveQuestionBreak, ReceiveQuestionSummary, ReceiveUserJoined, ReceiveUserLeft, ReceiveUserList))
import Urls exposing (websocketUrl)


initSocket : String -> Location -> Phoenix.Socket.Socket msg
initSocket token location =
    Phoenix.Socket.init (websocketUrl location token)
        |> Phoenix.Socket.withDebug


initializeRoom : Phoenix.Socket.Socket RoomMsg -> String -> ( Phoenix.Socket.Socket RoomMsg, Cmd (Phoenix.Socket.Msg RoomMsg) )
initializeRoom socket roomIdToString =
    let
        channel =
            Phoenix.Channel.init ("room:" ++ roomIdToString)

        roomTopic =
            "room:" ++ roomIdToString
    in
        Phoenix.Socket.join channel
            (socket
                |> Phoenix.Socket.on "event:user_joined" roomTopic ReceiveUserJoined
                |> Phoenix.Socket.on "event:user_left" roomTopic ReceiveUserLeft
                |> Phoenix.Socket.on "event:user_list" roomTopic ReceiveUserList
                |> Phoenix.Socket.on "event:post_question_summary" roomTopic ReceiveQuestionSummary
                |> Phoenix.Socket.on "question:answer_feedback" roomTopic ReceiveAnswerFeedback
                |> Phoenix.Socket.on "question:current_question" roomTopic ReceiveQuestion
                |> Phoenix.Socket.on "question:display_question" roomTopic ReceiveDisplayQuestion
                |> Phoenix.Socket.on "question:question_break" roomTopic ReceiveQuestionBreak
            )


leaveRoom :
    String
    -> Phoenix.Socket.Socket RoomMsg
    -> ( Phoenix.Socket.Socket RoomMsg, Cmd (Phoenix.Socket.Msg RoomMsg) )
leaveRoom roomId socket =
    Phoenix.Socket.leave ("room:" ++ roomId) socket


sendAnswer :
    String
    -> Json.Encode.Value
    -> Phoenix.Socket.Socket RoomMsg
    -> ( Phoenix.Socket.Socket RoomMsg, Cmd (Phoenix.Socket.Msg RoomMsg) )
sendAnswer roomId payload socket =
    Phoenix.Push.init "question:new_answer" ("room:" ++ roomId)
        |> Phoenix.Push.withPayload payload
        |> Phoenix.Push.onOk (\rawFeedback -> ReceiveAnswerFeedback rawFeedback)
        |> (flip Phoenix.Socket.push) socket
