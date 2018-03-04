module General.Update exposing (..)

import General.Models exposing (Model)
import General.Msgs exposing (GeneralMsg(OnFetchRooms))


update : GeneralMsg -> Model -> ( Model, Cmd GeneralMsg )
update msg model =
    case msg of
        OnFetchRooms response ->
            { model | rooms = response } ! []
