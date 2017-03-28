module Update exposing (..)

import Models exposing (Model)
import Msgs exposing (Msg(..))
import Routing exposing (parseLocation)
import Debug exposing (log)

update: Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Username username ->
      ({ model | username = username }, Cmd.none)
    Msgs.OnLocationChange location ->
      let
        newRoute =
          parseLocation location
      in
        ( { model | route = newRoute }, Cmd.none )
