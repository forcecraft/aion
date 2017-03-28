module Routing exposing (..)

import Navigation exposing (Location)
import Models exposing (Route(..))
import UrlParser exposing (..)


matchers: Parser (Route -> a) a
matchers =
  oneOf
    [ map LoginRoute top
    , map RoomsRoute (s "rooms")
    ]


parseLocation: Location -> Route
parseLocation location =
  case (parseHash matchers location) of
    Just route ->
      route

    Nothing ->
      NotFoundRoute


-- PATHS
roomsPath: String
roomsPath =
  "#rooms"
