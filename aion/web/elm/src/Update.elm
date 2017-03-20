module Update exposing (..)

import Models exposing (Model)
import Msgs exposing (Msg(..))

update: Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Username username ->
      ({ model | username = username }, Cmd.none)
