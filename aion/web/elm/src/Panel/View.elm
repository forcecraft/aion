module Panel.View exposing (..)

import Bootstrap.Badge as Badge
import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Select as Select
import Forms
import General.Models exposing (Model)
import General.Notifications exposing (toastsConfig)
import Html exposing (..)
import Html.Attributes exposing (class, for, placeholder, type_, value)
import Msgs exposing (Msg(..))
import Multiselect
import Panel.Models exposing (CategoriesData, Category)
import RemoteData exposing (WebData)
import Toasty
import Toasty.Defaults


panelView : Model -> Html Msg
panelView model =
    div [ class "panel-container" ]
        [ h4 [] [ text "Create new question for certain category:" ]
        , Form.form []
            [ questionFormElement model.panelData.questionForm
            , answersFormElement model.panelData.questionForm
            , categoryFormElement model.panelData.questionForm (listCategories model.categories)
            , Button.button
                [ Button.success
                , Button.onClick CreateNewQuestionWithAnswers
                ]
                [ text "submit" ]
            , Toasty.view toastsConfig Toasty.Defaults.view ToastyMsg model.toasties
            ]
        , h4 [] [ text "Create new category:" ]
        , Form.form []
            [ categoryNameFormElement model.panelData.categoryForm
            , Button.button
                [ Button.success
                , Button.onClick CreateNewCategory
                ]
                [ text "submit" ]
            , Toasty.view toastsConfig Toasty.Defaults.view ToastyMsg model.toasties
            ]
        , h4 [] [ text "Create new Room:" ]
        , Form.form []
            [ roomFormElement model.panelData.roomForm
            , Form.group [] [ Html.map MultiselectMsg <| (Multiselect.view model.panelData.categoryMultiSelect) ]
            , Button.button
                [ Button.success
                , Button.onClick CreateNewRoom
                ]
                [ text "submit" ]
            ]
        ]



-- question form section


questionFormElement : Forms.Form -> Html Msg
questionFormElement form =
    Form.group []
        [ Form.label [ for "question" ] [ text "Enter question content below:" ]
        , Input.text
            [ Input.placeholder "How much is 2+2?"
            , Input.onInput (UpdateQuestionForm "question")
            , Input.value (Forms.formValue form "question")
            ]
        , Badge.pillInfo [] [ text (Forms.errorString form "question") ]
        ]


answersFormElement : Forms.Form -> Html Msg
answersFormElement form =
    Form.group []
        [ Form.label [ for "answer" ] [ text "Enter answer below, separate all posibilities with comma:" ]
        , Input.text
            [ Input.placeholder "4,four"
            , Input.onInput (UpdateQuestionForm "answers")
            , Input.value (Forms.formValue form "answers")
            ]
        , Badge.pillInfo [] [ text (Forms.errorString form "answers") ]
        ]


categoryFormElement : Forms.Form -> List Category -> Html Msg
categoryFormElement form categoryList =
    Form.group []
        [ Form.label [ for "category" ] [ text "Select the category to which to add the question:" ]
        , Select.select
            [ Select.onChange (UpdateQuestionForm "category") ]
            (Select.item [ value "0" ] [ text "--Select a category--" ]
                :: List.map
                    (\category -> Select.item [ value (category.id |> toString) ] [ text category.name ])
                    categoryList
            )
        , Badge.pillInfo [] [ text (Forms.errorString form "category") ]
        ]


listCategories : WebData CategoriesData -> List Category
listCategories result =
    case result of
        RemoteData.Success categoriesData ->
            categoriesData.data

        _ ->
            []



-- category form section


categoryNameFormElement : Forms.Form -> Html Msg
categoryNameFormElement form =
    Form.group []
        [ Form.label [ for "category" ] [ text "Enter category name below, should be uppercase:" ]
        , Input.text
            [ Input.placeholder "for instance: History or Famous people"
            , Input.onInput (UpdateCategoryForm "name")
            , Input.value (Forms.formValue form "name")
            ]
        , Badge.pillInfo [] [ text (Forms.errorString form "name") ]
        ]



-- room form section


roomFormElement : Forms.Form -> Html Msg
roomFormElement form =
    Form.group []
        [ Form.label [ for "room" ] [ text "Enter room name bellow, should be uppercase:" ]
        , Input.text
            [ Input.placeholder "Name..."
            , Input.onInput (UpdateRoomForm "name")
            , Input.value (Forms.formValue form "name")
            ]
        , Badge.pillInfo [] [ text (Forms.errorString form "name") ]
        , Input.text
            [ Input.placeholder "Description..."
            , Input.onInput (UpdateRoomForm "description")
            , Input.value (Forms.formValue form "description")
            ]
        , Badge.pillInfo [] [ text (Forms.errorString form "description") ]
        ]
