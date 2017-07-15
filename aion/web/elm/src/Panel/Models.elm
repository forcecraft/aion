module Panel.Models exposing (..)


type alias PanelData =
    { newQuestionContent : String
    , newAnswerContent : String
    , newAnswerCategory : String
    }


type alias QuestionCreatedData =
    { data : QuestionCreatedContent }


type alias QuestionCreatedContent =
    { subject_id : Int
    , image_name : String
    , id : Int
    , content : String
    }
