module Panel.Models exposing (..)

import Forms
import Panel.Validators exposing (answersValidations, questionValidations, subjectValidations)


type alias PanelData =
    { questionForm : QuestionForm
    }


type alias QuestionForm =
    Forms.Form


questionFormPossibleFields =
    [ "question", "answers", "subject" ]


questionForm : List ( String, List Forms.FieldValidator )
questionForm =
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
