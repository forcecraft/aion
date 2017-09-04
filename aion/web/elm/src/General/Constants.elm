module General.Constants exposing (..)


hostname : String
hostname =
    "http://localhost:4000/"


createCategoryUrl : String
createCategoryUrl =
    hostname ++ "api/subjects"


createQuestionUrl : String
createQuestionUrl =
    hostname ++ "api/questions"

createRoomUrl : String
createRoomUrl =
    hostname ++ "api/rooms"

