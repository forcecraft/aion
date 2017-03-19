module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


main =
  Html.beginnerProgram
    { model = model
    , view = view
    , update = update
    }


-- MODEL

type alias Model =
  { username: String }

model: Model
model =
  Model ""


-- UPDATE

type Msg
  = Username String

update: Msg -> Model -> Model
update msg model =
  case msg of
    Username username ->
      { model | username = username }


-- VIEW

view: Model -> Html Msg
view model =
  div []
    [ p [] [text "Welcome to Aion!"]
    , input [ type_ "text", placeholder "Username", onInput Username] []
    ]
