module Panel.Models exposing (..)

import Forms


type alias PanelData =
    { createQuestionForm : CreateQuestionForm
    }


type alias CreateQuestionForm =
    Forms.Form


createQuestionForm : List ( String, List Forms.FieldValidator )
createQuestionForm =
    [ ( "question", questionValidations )
    , ( "answers", questionValidations )
    , ( "subject", questionValidations )
    ]


questionValidations : List Forms.FieldValidator
questionValidations =
    [ Forms.validateExistence
    ]


type alias QuestionCreatedData =
    { data : QuestionCreatedContent }


type alias QuestionCreatedContent =
    { subject_id : Int
    , image_name : String
    , id : Int
    , content : String
    }
