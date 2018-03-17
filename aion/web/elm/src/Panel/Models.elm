module Panel.Models exposing (..)

import Forms
import Panel.Validators exposing (answersValidations, categoryNameValidations, questionValidations, categoryValidations)
import Multiselect
import RemoteData exposing (WebData)
import Toasty
import Toasty.Defaults


type alias PanelData =
    { categories : WebData CategoriesData
    , categoryForm : CategoryForm
    , categoryMultiSelect : Multiselect.Model
    , roomForm : RoomForm
    , questionForm : QuestionForm
    , toasties : Toasty.Stack Toasty.Defaults.Toast
    }


initPanelData : PanelData
initPanelData =
    { categories = RemoteData.Loading
    , categoryForm = Forms.initForm categoryForm
    , categoryMultiSelect = Multiselect.initModel [] "id"
    , roomForm = Forms.initForm roomForm
    , questionForm = Forms.initForm questionForm
    , toasties = Toasty.initialState
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



-- room form section


type alias RoomForm =
    Forms.Form


roomNamePossibleFields : List String
roomNamePossibleFields =
    [ "name", "description" ]


roomForm : List ( String, List Forms.FieldValidator )
roomForm =
    [ ( "name", [ Forms.validateExistence ] )
    , ( "description", [ Forms.validateExistence ] )
    ]


type alias RoomCreatedData =
    { data : RoomCreatedContent }


type alias RoomCreatedContent =
    { id : Int
    , name : String
    , description : String
    , category_ids : List String
    }
