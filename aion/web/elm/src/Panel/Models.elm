module Panel.Models exposing (..)

import Forms
import Panel.Validators exposing (answersValidations, categoryNameValidations, questionValidations, subjectValidations)
import Multiselect


type alias PanelData =
    { questionForm : QuestionForm
    , categoryForm : CategoryForm
    , roomForm : RoomForm
    , categoryMultiSelect : Multiselect.Model
    }



-- question form section


type alias QuestionForm =
    Forms.Form


questionFormPossibleFields : List String
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



-- category form section


type alias CategoryForm =
    Forms.Form


categoryNamePossibleFields : List String
categoryNamePossibleFields =
    [ "name" ]


categoryForm : List ( String, List Forms.FieldValidator )
categoryForm =
    [ ( "name", categoryNameValidations ) ]


type alias CategoryCreatedData =
    { data : CategoryCreatedContent }


type alias CategoryCreatedContent =
    { id : Int
    , name : String
    }



-- room form section


type alias RoomForm =
    Forms.Form


roomNamePossibleFields : List String
roomNamePossibleFields =
    [ "name", "description" ]


roomForm : List ( String, List Forms.FieldValidator )
roomForm =
    [ ( "name", [ Forms.validateExistence ] )
    , ( "description", [ Forms.validateExistence ] )]


type alias RoomCreatedData =
    { data : RoomCreatedContent }


type alias RoomCreatedContent =
    { id : Int, name : String
    , description : String
    , subject_ids : List(String)
    }
