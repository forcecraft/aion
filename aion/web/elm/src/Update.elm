module Update exposing (..)

import Models exposing (Model)
import Msgs exposing (Msg(..))
import Routing exposing (parseLocation)


update: Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    UpdateUsername username ->
      ({ model | username = username }, Cmd.none)
    OnLocationChange location ->
      let
        newRoute =
          parseLocation location
      in
        ( { model | route = newRoute }, Cmd.none )
