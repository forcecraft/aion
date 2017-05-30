module Routing exposing (..)

import General.Models exposing (Route(LoginRoute, NotFoundRoute, RoomListRoute, RoomRoute))
import Navigation exposing (Location)
import UrlParser exposing (..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map LoginRoute top
        , map RoomRoute (s "rooms" </> int)
        , map RoomListRoute (s "rooms")
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
