module Models exposing (..)

type alias Model =
  { username: String
  , rooms: List Room
  , route: Route
  }

type alias Room =
    String

initialModel: Route -> Model
initialModel route =
  { username = ""
  , rooms = ["fizyka", "historia", "matematyka"]
  , route = route
  }

-- ROUTING
type Route
  = LoginRoute
  | RoomsRoute
  | NotFoundRoute
