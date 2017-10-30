module Urls exposing (..)

import Navigation exposing (Location)


hostname : Location -> String
hostname location =
    location.host


host : Location -> String
host location =
    location.protocol ++ "//" ++ (hostname location) ++ "/"


categoriesUrl : Location -> String
categoriesUrl location =
    (host location) ++ "api/categories"


questionsUrl : Location -> String
questionsUrl location =
    (host location) ++ "api/questions"


roomsUrl : Location -> String
roomsUrl location =
    (host location) ++ "api/rooms?with_counts=true"


loginUrl : Location -> String
loginUrl location =
    (host location) ++ "sessions"


registerUrl : Location -> String
registerUrl location =
    (host location) ++ "register"


websocketUrl : Location -> String -> String
websocketUrl location token =
    "ws://" ++ (hostname location) ++ "/socket/websocket?token=" ++ token
