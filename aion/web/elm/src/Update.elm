module Update exposing (..)

import Auth.Msgs exposing (AuthMsg(LoginResult, RegistrationResult))
import Auth.Update
import General.Models exposing (Model, Route(LobbyRoute, RankingRoute, RoomRoute, UserRoute))
import Lobby.Api exposing (fetchRooms)
import Lobby.Update
import Msgs exposing (Msg(LeaveRoom, MkAuthMsg, MkLobbyMsg, MkPanelMsg, MkRankingMsg, MkRoomMsg, MkUserMsg, NavbarMsg, OnLocationChange))
import Panel.Api
import Panel.Update
import Ranking.Api exposing (fetchRanking)
import Ranking.Update
import RemoteData
import Room.Models exposing (cleanRoomData)
import Room.Msgs exposing (RoomMsg(PhoenixMsg))
import Room.Socket exposing (initializeRoom, leaveRoom)
import Room.Update
import Routing exposing (parseLocation)
import UpdateHelpers exposing (postTokenActions, withLocation, withToken)
import User.Api exposing (fetchUserScores)
import User.Msgs exposing (UserMsg(Logout))
import User.Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        --sub-modules
        MkRoomMsg subMsg ->
            let
                ( updatedModel, cmd ) =
                    Room.Update.update subMsg model.roomData
            in
                { model | roomData = updatedModel } ! [ Cmd.map MkRoomMsg cmd ]

        MkUserMsg subMsg ->
            if User.Api.unauthorized subMsg then
                update (MkUserMsg Logout) model
            else
                let
                    ( updatedModel, cmd ) =
                        User.Update.update subMsg model.userData
                in
                    { model | userData = updatedModel } ! [ Cmd.map MkUserMsg cmd ]

        MkRankingMsg subMsg ->
            if Ranking.Api.unauthorized subMsg then
                update (MkUserMsg Logout) model
            else
                let
                    ( updatedModel, cmd ) =
                        Ranking.Update.update subMsg model.rankingData
                in
                    { model | rankingData = updatedModel } ! [ Cmd.map MkRankingMsg cmd ]

        MkPanelMsg subMsg ->
            if Panel.Api.unauthorized subMsg then
                update (MkUserMsg Logout) model
            else
                let
                    ( updatedModel, cmd ) =
                        Panel.Update.update subMsg model.panelData
                in
                    { model | panelData = updatedModel } ! [ Cmd.map MkPanelMsg cmd ]

        MkLobbyMsg subMsg ->
            if Lobby.Api.unauthorized subMsg then
                update (MkUserMsg Logout) model
            else
                let
                    ( updatedModel, cmd ) =
                        Lobby.Update.update subMsg model.lobbyData
                in
                    { model | lobbyData = updatedModel } ! [ Cmd.map MkLobbyMsg cmd ]

        MkAuthMsg subMsg ->
            let
                ( updatedModel, cmd ) =
                    Auth.Update.update subMsg model.authData

                extraCmds =
                    case subMsg of
                        LoginResult (Ok token) ->
                            postTokenActions token model.location

                        RegistrationResult (RemoteData.Success response) ->
                            postTokenActions response.token model.location

                        _ ->
                            []
            in
                { model | authData = updatedModel }
                    ! ([ Cmd.map MkAuthMsg cmd ] ++ extraCmds)

        --the rest
        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location

                ( newModel, afterLeaveCmd ) =
                    update LeaveRoom model
            in
                case newRoute of
                    RoomRoute roomId ->
                        let
                            ( initializeRoomSocket, initializeRoomCmd ) =
                                initializeRoom newModel.roomData.socket (toString roomId)
                        in
                            { newModel
                                | roomData = cleanRoomData roomId initializeRoomSocket newModel.roomData
                                , route = newRoute
                            }
                                ! [ afterLeaveCmd
                                  , initializeRoomCmd
                                        |> Cmd.map PhoenixMsg
                                        |> Cmd.map MkRoomMsg
                                  ]

                    LobbyRoute ->
                        { newModel | route = newRoute }
                            ! [ afterLeaveCmd
                              , fetchRooms
                                    |> withLocation model
                                    |> withToken model
                                    |> Cmd.map MkLobbyMsg
                              ]

                    RankingRoute ->
                        { model | route = newRoute }
                            ! [ afterLeaveCmd
                              , fetchRanking
                                    |> withLocation model
                                    |> withToken model
                                    |> Cmd.map MkRankingMsg
                              ]

                    UserRoute ->
                        { model | route = newRoute }
                            ! [ afterLeaveCmd
                              , fetchUserScores
                                    |> withLocation model
                                    |> withToken model
                                    |> Cmd.map MkUserMsg
                              ]

                    _ ->
                        { newModel | route = newRoute } ! [ afterLeaveCmd ]

        LeaveRoom ->
            case model.route of
                RoomRoute id ->
                    let
                        ( leaveRoomSocket, leaveRoomCmd ) =
                            leaveRoom (toString id) model.roomData.socket

                        oldRoomData =
                            model.roomData

                        newRoomData =
                            { oldRoomData | socket = leaveRoomSocket }
                    in
                        { model | roomData = newRoomData }
                            ! [ leaveRoomCmd
                                    |> Cmd.map PhoenixMsg
                                    |> Cmd.map MkRoomMsg
                              ]

                _ ->
                    model ! []

        -- Navbar
        NavbarMsg state ->
            { model | navbarState = state } ! []
