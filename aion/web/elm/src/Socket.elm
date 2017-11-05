module Socket exposing (..)

import Msgs exposing (Msg(ReceiveAnswerFeedback, ReceiveDisplayQuestion, ReceiveQuestion, ReceiveQuestionBreak, ReceiveUserJoined, ReceiveUserList))
import Navigation exposing (Location)
import Phoenix.Channel
import Phoenix.Socket
import Urls exposing (websocketUrl)


initSocket : String -> Location -> Phoenix.Socket.Socket msg
initSocket token location =
    Phoenix.Socket.init (websocketUrl location token)
        |> Phoenix.Socket.withDebug


initializeRoom : Phoenix.Socket.Socket Msg -> String -> ( Phoenix.Socket.Socket Msg, Cmd (Phoenix.Socket.Msg Msg) )
initializeRoom socket roomIdToString =
    let
        channel =
            Phoenix.Channel.init ("room:" ++ roomIdToString)

        roomTopic =
            "room:" ++ roomIdToString
    in
        Phoenix.Socket.join channel
            (socket
                |> Phoenix.Socket.on "user_list" roomTopic ReceiveUserList
                |> Phoenix.Socket.on "answer_feedback" roomTopic ReceiveAnswerFeedback
                |> Phoenix.Socket.on "user_joined" roomTopic ReceiveUserJoined
                |> Phoenix.Socket.on "current_question" roomTopic ReceiveQuestion
                |> Phoenix.Socket.on "display_question" roomTopic ReceiveDisplayQuestion
                |> Phoenix.Socket.on "question_break" roomTopic ReceiveQuestionBreak
            )


leaveRoom : String -> Phoenix.Socket.Socket Msg -> ( Phoenix.Socket.Socket Msg, Cmd (Phoenix.Socket.Msg Msg) )
leaveRoom roomId socket =
    Phoenix.Socket.leave ("room:" ++ roomId) socket
