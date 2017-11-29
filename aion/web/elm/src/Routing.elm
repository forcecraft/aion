module Routing exposing (..)

import General.Models exposing (Route(AuthRoute, CreateRoomRoute, NotFoundRoute, RankingRoute, RoomListRoute, RoomRoute, UserRoute))
import Navigation exposing (Location)
import UrlParser exposing (..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map RoomListRoute top
        , map AuthRoute (s "auth")
        , map RoomRoute (s "rooms" </> int)
        , map CreateRoomRoute (s "create_room")
        , map RankingRoute (s "rankings")
        , map UserRoute (s "profile")
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
