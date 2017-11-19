module Ranking.Urls exposing (..)

import Navigation exposing (Location)
import Room.Constants exposing (defaultImagePath, imagesPath)


goldMedalPath : String
goldMedalPath = "medal_gold.png"


silverMedalPath : String
silverMedalPath = "medal_silver.png"


bronzeMedalPath : String
bronzeMedalPath = "medal_bronze.png"


getGoldMedalImageUrl : Location -> String
getGoldMedalImageUrl location =
    (imagesPath location) ++ goldMedalPath


getSilverMedalImageUrl : Location -> String
getSilverMedalImageUrl location =
    (imagesPath location) ++ silverMedalPath


getBronzeMedalImageUrl : Location -> String
getBronzeMedalImageUrl location =
    (imagesPath location) ++ bronzeMedalPath
