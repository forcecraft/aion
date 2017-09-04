module Socket exposing (..)

import Msgs exposing (Msg(ReceiveAnswerFeedback, ReceiveQuestion, ReceiveUserJoined, ReceiveUserList))
import Phoenix.Channel
import Phoenix.Socket


initializeRoom : Phoenix.Socket.Socket Msg -> String -> ( Phoenix.Socket.Socket Msg, Cmd (Phoenix.Socket.Msg Msg) )
initializeRoom socket roomIdToString =
    let
        channel =
            Phoenix.Channel.init ("rooms:" ++ roomIdToString)
    in
        Phoenix.Socket.join channel
            (socket
                |> Phoenix.Socket.on "user:list" ("rooms:" ++ roomIdToString) ReceiveUserList
                |> Phoenix.Socket.on "new:question" ("rooms:" ++ roomIdToString) ReceiveQuestion
                |> Phoenix.Socket.on "answer:feedback" ("rooms:" ++ roomIdToString) ReceiveAnswerFeedback
                |> Phoenix.Socket.on "room:user:joined" ("rooms:" ++ roomIdToString) ReceiveUserJoined
            )


leaveRoom : String -> Phoenix.Socket.Socket Msg -> ( Phoenix.Socket.Socket Msg, Cmd (Phoenix.Socket.Msg Msg) )
leaveRoom roomId socket =
    Phoenix.Socket.leave ("rooms:" ++ roomId) socket
