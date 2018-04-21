module Urls exposing (..)

import Auth.Models exposing (Token)
import Navigation exposing (Location)


type alias Url =
    String


type alias Path =
    String


hostname : Location -> Url
hostname location =
    location.host


host : Location -> Url
host location =
    location.protocol ++ "//" ++ (hostname location) ++ "/"


categoriesUrl : Location -> Url
categoriesUrl location =
    (host location) ++ "api/categories"


questionsUrl : Location -> Url
questionsUrl location =
    (host location) ++ "api/questions"


roomsUrl : Location -> Url
roomsUrl location =
    (host location) ++ "api/rooms?with_counts=true"


rankingUrl : Location -> Url
rankingUrl location =
    (host location) ++ "api/ranking"


userScoresUrl : Location -> Url
userScoresUrl location =
    (host location) ++ "api/user_ranking"


loginUrl : Location -> Url
loginUrl location =
    (host location) ++ "sessions"


registerUrl : Location -> Url
registerUrl location =
    (host location) ++ "register"


websocketUrl : Location -> Token -> Url
websocketUrl location token =
    "wss://" ++ (hostname location) ++ "/socket/websocket?token=" ++ token



-- local urls
-- calling local urls "paths" in order to distinguish between rankingUrl and rankingPath etc.


lobbyPath : Path
lobbyPath =
    "#"


createRoomPath : Path
createRoomPath =
    "#create_room"


panelPath : Path
panelPath =
    "#panel"


userPath : Path
userPath =
    "#profile"


rankingPath : Path
rankingPath =
    "#rankings"
