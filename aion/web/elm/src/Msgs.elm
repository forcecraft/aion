module Msgs exposing (..)

import Auth.Msgs exposing (AuthMsg)
import Bootstrap.Navbar as Navbar
import Lobby.Msgs exposing (LobbyMsg)
import Navigation exposing (Location)
import Panel.Msgs exposing (PanelMsg)
import Ranking.Msgs exposing (RankingMsg)
import Room.Msgs exposing (RoomMsg)
import User.Msgs exposing (UserMsg)


type Msg
    = OnLocationChange Location
    | NavbarMsg Navbar.State
    | LeaveRoom
      -- sub page types
    | MkRoomMsg RoomMsg
    | MkRankingMsg RankingMsg
    | MkUserMsg UserMsg
    | MkPanelMsg PanelMsg
    | MkAuthMsg AuthMsg
    | MkLobbyMsg LobbyMsg
