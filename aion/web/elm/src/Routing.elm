module Routing exposing (..)

import Models exposing (Route(AuthRoute, CreateRoomRoute, LobbyRoute, NotFoundRoute, RankingRoute, RoomRoute, UserRoute))
import Navigation exposing (Location)
import UrlParser exposing (..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map LobbyRoute top
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
