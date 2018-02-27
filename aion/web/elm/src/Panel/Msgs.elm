module Panel.Msgs exposing (..)

import Panel.Models exposing (CategoriesData, CategoryCreatedData, QuestionCreatedData, RoomCreatedData)
import RemoteData exposing (WebData)
import Toasty
import Toasty.Defaults


type PanelMsg
    = UpdateQuestionForm String String
    | UpdateCategoryForm String String
    | UpdateRoomForm String String
    | OnQuestionCreated (WebData QuestionCreatedData)
    | OnCategoryCreated (WebData CategoryCreatedData)
    | OnRoomCreated (WebData RoomCreatedData)
    | CreateNewQuestionWithAnswers
    | CreateNewCategory
    | CreateNewRoom
    | OnFetchCategories (WebData CategoriesData)
    | ToastyMsg (Toasty.Msg Toasty.Defaults.Toast)
