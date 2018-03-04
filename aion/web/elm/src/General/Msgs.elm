module General.Msgs exposing (..)

import RemoteData exposing (WebData)
import Room.Models exposing (RoomsData)


type GeneralMsg
    = OnFetchRooms (WebData RoomsData)
