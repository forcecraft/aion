module Panel.Models exposing (..)

import Forms
import Panel.Validators exposing (answersValidations, questionValidations, subjectValidations)


type alias PanelData =
    { createQuestionForm : CreateQuestionForm
    }


type alias CreateQuestionForm =
    Forms.Form


createQuestionForm : List ( String, List Forms.FieldValidator )
createQuestionForm =
    [ ( "question", questionValidations )
    , ( "answers", answersValidations )
    , ( "subject", subjectValidations )
    ]


type alias QuestionCreatedData =
    { data : QuestionCreatedContent }


type alias QuestionCreatedContent =
    { subject_id : Int
    , image_name : String
    , id : Int
    , content : String
    }
