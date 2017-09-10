module Panel.Models exposing (..)

import Forms
import Panel.Validators exposing (answersValidations, categoryNameValidations, questionValidations, categoryValidations)


type alias PanelData =
    { questionForm : QuestionForm
    , categoryForm : CategoryForm
    }



-- question form section


type alias QuestionForm =
    Forms.Form


questionFormPossibleFields : List String
questionFormPossibleFields =
    [ "question", "answers", "category" ]


questionForm : List ( String, List Forms.FieldValidator )
questionForm =
    [ ( "question", questionValidations )
    , ( "answers", answersValidations )
    , ( "category", categoryValidations )
    ]


type alias QuestionCreatedData =
    { data : QuestionCreatedContent }


type alias QuestionCreatedContent =
    { category_id : Int
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


type alias Category =
    { id : Int
    , name : String
    }


type alias CategoriesData =
    { data : List Category }
