module Routing exposing (..)

import General.Models exposing (Route(LoginRoute, NotFoundRoute, RoomRoute, RoomsRoute))
import Navigation exposing (Location)
import UrlParser exposing (..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map LoginRoute top
        , map RoomRoute (s "rooms" </> int)
        , map RoomsRoute (s "rooms")
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


roomsPath : String
roomsPath =
    "#rooms"
