module General.Update exposing (..)

import General.Models exposing (Model)
import Msgs exposing (Msg(OnFetchRooms))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchRooms response ->
            { model | rooms = response } ! []
