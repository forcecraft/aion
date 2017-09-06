module Urls exposing (..)

import Navigation exposing (Location)


hostname : Location -> String
hostname location =
    location.host


host : Location -> String
host location =
    location.protocol ++ "//" ++ (hostname location) ++ "/"


createCategoryUrl : Location -> String
createCategoryUrl location =
    (host location) ++ "api/subjects"


createQuestionUrl : Location -> String
createQuestionUrl location =
    (host location) ++ "api/questions"
