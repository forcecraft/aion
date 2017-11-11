module Routing exposing (..)

import General.Models exposing (Route(AuthRoute, NotFoundRoute, RoomListRoute, RoomRoute, UserRoute, RankingRoute))
import Navigation exposing (Location)
import UrlParser exposing (..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map RoomListRoute top
        , map AuthRoute (s "auth")
        , map RoomRoute (s "rooms" </> int)
        , map UserRoute (s "profile")
        , map RankingRoute (s "rankings")
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
