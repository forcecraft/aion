module Routing exposing (..)

import General.Models exposing (Route(HomeRoute, AuthRoute, NotFoundRoute, PanelRoute, RoomListRoute, RoomRoute, UserRoute))
import Navigation exposing (Location)
import UrlParser exposing (..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map HomeRoute top
        , map AuthRoute (s "auth")
        , map RoomRoute (s "rooms" </> int)
        , map RoomListRoute (s "rooms")
        , map PanelRoute (s "panel")
        , map UserRoute (s "profile")
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


panelPath : String
panelPath =
    "#panel"


userPath : String
userPath =
    "#profile"
