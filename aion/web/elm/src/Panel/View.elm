module Panel.View exposing (..)

import Bootstrap.Badge as Badge
import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Select as Select
import Forms
import General.Models exposing (Model)
import Html exposing (..)
import Html.Attributes exposing (class, for, placeholder, type_, value)
import Multiselect
import Panel.Models exposing (CategoriesData, Category)
import Panel.Msgs exposing (PanelMsg(CreateNewCategory, CreateNewQuestionWithAnswers, CreateNewRoom, MultiselectMsg, ToastyMsg, UpdateCategoryForm, UpdateQuestionForm, UpdateRoomForm))
import Panel.Notifications exposing (toastsConfig)
import RemoteData exposing (WebData)
import Toasty
import Toasty.Defaults


panelView : Model -> Html PanelMsg
panelView model =
    div [ class "panel-container" ]
        [ h5 [] [ text "Create room" ]
        , renderRoomForm model.panelData.roomForm model.panelData.categoryMultiSelect
        , Toasty.view toastsConfig Toasty.Defaults.view ToastyMsg model.toasties
        ]



-- question form section


renderQuestionForm : Forms.Form -> WebData CategoriesData -> Html PanelMsg
renderQuestionForm questionForm categories =
    Form.form []
        [ questionFormElement questionForm
        , answersFormElement questionForm
        , categoryFormElement questionForm (listCategories categories)
        , Button.button
            [ Button.success
            , Button.onClick CreateNewQuestionWithAnswers
            ]
            [ text "submit" ]
        ]


questionFormElement : Forms.Form -> Html PanelMsg
questionFormElement form =
    Form.group []
        [ Form.label [ for "question" ] [ text "Enter question content below:" ]
        , Input.text
            [ Input.placeholder "How much is 2 + 2?"
            , Input.onInput (UpdateQuestionForm "question")
            , Input.value (Forms.formValue form "question")
            ]
        , Badge.badgeSuccess [] [ text (Forms.errorString form "question") ]
        ]


answersFormElement : Forms.Form -> Html PanelMsg
answersFormElement form =
    Form.group []
        [ Form.label [ for "answer" ] [ text "Enter correct answers below, separate all posibilities with commas:" ]
        , Input.text
            [ Input.placeholder "4,four"
            , Input.onInput (UpdateQuestionForm "answers")
            , Input.value (Forms.formValue form "answers")
            ]
        , Badge.badgeSuccess [] [ text (Forms.errorString form "answers") ]
        ]


categoryFormElement : Forms.Form -> List Category -> Html PanelMsg
categoryFormElement form categoryList =
    Form.group []
        [ Form.label [ for "category" ] [ text "Select a category:" ]
        , Select.select
            [ Select.onChange (UpdateQuestionForm "category") ]
            (Select.item [ value "0" ] [ text "--select a category--" ]
                :: List.map
                    (\category -> Select.item [ value (category.id |> toString) ] [ text category.name ])
                    categoryList
            )
        , Badge.badgeSuccess [] [ text (Forms.errorString form "category") ]
        ]


listCategories : WebData CategoriesData -> List Category
listCategories result =
    case result of
        RemoteData.Success categoriesData ->
            categoriesData.data

        _ ->
            []



-- category form section


renderCategoryForm : Forms.Form -> Html PanelMsg
renderCategoryForm categoryForm =
    Form.form []
        [ categoryNameFormElement categoryForm
        , Button.button
            [ Button.success
            , Button.onClick CreateNewCategory
            ]
            [ text "submit" ]
        ]


categoryNameFormElement : Forms.Form -> Html PanelMsg
categoryNameFormElement form =
    Form.group []
        [ Form.label [ for "category" ] [ text "Enter category name below:" ]
        , Input.text
            [ Input.placeholder "Discrete mathematics"
            , Input.onInput (UpdateCategoryForm "name")
            , Input.value (Forms.formValue form "name")
            ]
        , Badge.badgeSuccess [] [ text (Forms.errorString form "name") ]
        ]



-- room form section


renderRoomForm : Forms.Form -> Multiselect.Model -> Html PanelMsg
renderRoomForm form categoryMultiSelect =
    Form.form []
        [ Form.group []
            [ Form.label [ for "room" ] [ text "Name" ]
            , Input.text
                [ Input.placeholder "Pancake Party"
                , Input.onInput (UpdateRoomForm "name")
                , Input.value (Forms.formValue form "name")
                ]
            , Badge.badgeSuccess [] [ text (Forms.errorString form "name") ]
            , Form.label [ for "room", class "room-form-label" ] [ text "Description" ]
            , Input.text
                [ Input.placeholder "Gathering the best pancake lovers and testing their pancake knowledge"
                , Input.onInput (UpdateRoomForm "description")
                , Input.value (Forms.formValue form "description")
                ]
            , Badge.badgeSuccess [] [ text (Forms.errorString form "description") ]
            , Form.label [ for "room", class "room-form-label" ] [ text "Categories" ]
            , Form.group [] [ Html.map MultiselectMsg <| (Multiselect.view categoryMultiSelect) ]
            , Button.button
                [ Button.success
                , Button.onClick CreateNewRoom
                ]
                [ text "submit" ]
            ]
        ]
