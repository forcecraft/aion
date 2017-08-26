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
import Html.Attributes exposing (for, placeholder, type_, value)
import Html.Events exposing (onClick, onInput, onWithOptions)
import Msgs exposing (Msg(..))
import RemoteData exposing (WebData)
import Room.Models exposing (Room, RoomsData)
import Toasty
import Toasty.Defaults


panelView : Model -> Html Msg
panelView model =
    div []
        [ h4 [] [ text "Create new question for certain category:" ]
        , Form.form []
            [ questionFormElement model.panelData.questionForm
            , answersFormElement model.panelData.questionForm
            , subjectFormElement model.panelData.questionForm (listRooms model.rooms)
            , Button.button
                [ Button.success
                , Button.attrs [ onClick CreateNewQuestionWithAnswers ]
                ]
                [ text "submit" ]
            , Toasty.view toastsConfig Toasty.Defaults.view ToastyMsg model.toasties
            ]
        , h4 [] [ text "Create new category:" ]
        , Form.form []
            [ categoryNameFormElement model.panelData.categoryForm
            , Button.button
                [ Button.success
                , Button.attrs [ onClick CreateNewCategory ]
                ]
                [ text "submit" ]
            , Toasty.view toastsConfig Toasty.Defaults.view ToastyMsg model.toasties
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


subjectFormElement : Forms.Form -> List Room -> Html Msg
subjectFormElement form roomList =
    Form.group []
        [ Form.label [ for "category" ] [ text "Select the category to which to add the question:" ]
        , Select.select
            [ Select.onChange (UpdateQuestionForm "subject") ]
            (Select.item [ value "0" ] [ text "--Select a category--" ]
                :: List.map
                    (\room -> Select.item [ value (room.id |> toString) ] [ text room.name ])
                    roomList
            )
        , Badge.pillInfo [] [ text (Forms.errorString form "subject") ]
        ]


listRooms : WebData RoomsData -> List Room
listRooms result =
    case result of
        RemoteData.Success roomsData ->
            roomsData.data

        _ ->
            []



-- category form section


categoryNameFormElement : Forms.Form -> Html Msg
categoryNameFormElement form =
    Form.group []
        [ Form.label [ for "category" ] [ text "Enter category name bellow, should be uppercase:" ]
        , Input.text
            [ Input.placeholder "for instance: History or Famous people"
            , Input.onInput (UpdateCategoryForm "name")
            , Input.value (Forms.formValue form "name")
            ]
        , Badge.pillInfo [] [ text (Forms.errorString form "name") ]
        ]
