module Update exposing (..)

import Auth.Msgs exposing (AuthMsg(LoginResult, RegistrationResult))
import Auth.Update
import General.Models exposing (Model, Route(RankingRoute, UserRoute, RoomListRoute, RoomRoute))
import Lobby.Api
import Lobby.Update
import Msgs exposing (Msg(..))
import Panel.Api
import Panel.Update
import Ranking.Api exposing (fetchRanking)
import Ranking.Update
import RemoteData
import Room.Api exposing (fetchRooms)
import Room.Msgs exposing (RoomMsg(PhoenixMsg))
import Room.Update
import Routing exposing (parseLocation)
import Toasty
import Socket exposing (initSocket, initializeRoom, leaveRoom, sendAnswer)
import UpdateHelpers exposing (decodeAndUpdate, postTokenActions, updateForm, withLocation, withToken)
import User.Api exposing (fetchCurrentUser, fetchUserScores)
import User.Msgs exposing (UserMsg(Logout))
import User.Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        --sub-modules
        MkRoomMsg subMsg ->
            let
                ( updatedModel, cmd ) =
                    Room.Update.update subMsg model
            in
                updatedModel ! [ Cmd.map MkRoomMsg cmd ]

        MkUserMsg subMsg ->
            if User.Api.unauthorized subMsg then
                update (MkUserMsg Logout) model
            else
                let
                    ( updatedModel, cmd ) =
                        User.Update.update subMsg model
                in
                    updatedModel ! [ Cmd.map MkUserMsg cmd ]

        MkRankingMsg subMsg ->
            if Ranking.Api.unauthorized subMsg then
                update (MkUserMsg Logout) model
            else
                let
                    ( updatedModel, cmd ) =
                        Ranking.Update.update subMsg model
                in
                    updatedModel ! [ Cmd.map MkRankingMsg cmd ]

        MkPanelMsg subMsg ->
            if Panel.Api.unauthorized subMsg then
                update (MkUserMsg Logout) model
            else
                let
                    ( updatedModel, cmd ) =
                        Panel.Update.update subMsg model
                in
                    updatedModel ! [ Cmd.map MkPanelMsg cmd ]

        MkLobbyMsg subMsg ->
            if Lobby.Api.unauthorized subMsg then
                update (MkUserMsg Logout) model
            else
                let
                    ( updatedModel, cmd ) =
                        Lobby.Update.update subMsg model
                in
                    updatedModel ! [ Cmd.map MkLobbyMsg cmd ]

        MkAuthMsg subMsg ->
            let
                ( updatedModel, cmd ) =
                    Auth.Update.update subMsg model

                extraCmds =
                    case subMsg of
                        LoginResult (Ok token) ->
                            postTokenActions token model.location

                        RegistrationResult (RemoteData.Success response) ->
                            postTokenActions response.token model.location

                        _ ->
                            []
            in
                updatedModel
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
                                initializeRoom newModel.socket (toString roomId)
                        in
                            { newModel
                                | eventLog = []
                                , route = newRoute
                                , roomId = roomId
                                , socket = initializeRoomSocket
                                , toasties = Toasty.initialState
                            }
                                ! [ afterLeaveCmd
                                  , initializeRoomCmd
                                        |> Cmd.map PhoenixMsg
                                        |> Cmd.map MkRoomMsg
                                  ]

                    RoomListRoute ->
                        { newModel | route = newRoute }
                            ! [ afterLeaveCmd
                              , fetchRooms
                                    |> withLocation model
                                    |> withToken model
                                    |> Cmd.map MkGeneralMsg
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
                            leaveRoom (toString id) model.socket
                    in
                        { model | socket = leaveRoomSocket }
                            ! [ leaveRoomCmd
                                    |> Cmd.map PhoenixMsg
                                    |> Cmd.map MkRoomMsg
                              ]

                _ ->
                    model ! []

        -- Navbar
        NavbarMsg state ->
            { model | navbarState = state } ! []
