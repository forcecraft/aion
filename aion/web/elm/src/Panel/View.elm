module Panel.View exposing (..)

import Forms
import General.Models exposing (Model)
import General.Notifications exposing (toastsConfig)
import Html exposing (..)
import Html.Attributes exposing (placeholder, type_, value)
import Html.Events exposing (onClick, onInput, onWithOptions)
import Msgs exposing (Msg(..))
import RemoteData exposing (WebData)
import Room.Models exposing (RoomsData)
import Select
import Toasty
import Toasty.Defaults


panelView : Model -> Html Msg
panelView model =
    div []
        [ h3 [] [ text "Create new question for certain category:" ]
        , form []
            [ questionFormElement model.panelData.questionForm
            , answersFormElement model.panelData.questionForm
            , subjectFormElement model.panelData.questionForm (listRooms model.rooms)
            , input [ type_ "button", value "submit", onClick CreateNewQuestionWithAnswers ] []
            ]
        , h3 [] [ text "Create new category:" ]
        , form []
            [ categoryNameFormElement model.panelData.categoryForm
            , input [ type_ "button", value "submit", onClick CreateNewCategory ] []
            , Toasty.view toastsConfig Toasty.Defaults.view ToastyMsg model.toasties
            ]
        ]



-- question form section


questionFormElement : Forms.Form -> Html Msg
questionFormElement form =
    div []
        [ p [] [ text "Enter question content below:" ]
        , input
            [ placeholder "How much is 2+2?"
            , onInput (UpdateQuestionForm "question")
            , value (Forms.formValue form "question")
            ]
            []
        , small [] [ text (Forms.errorString form "question") ]
        ]


answersFormElement : Forms.Form -> Html Msg
answersFormElement form =
    div []
        [ p [] [ text "Enter answer below, separate all posibilities with comma:" ]
        , input
            [ placeholder "4,four"
            , onInput (UpdateQuestionForm "answers")
            , value (Forms.formValue form "answers")
            ]
            []
        , small [] [ text (Forms.errorString form "answers") ]
        ]


subjectFormElement : Forms.Form -> List String -> Html Msg
subjectFormElement form roomList =
    div []
        [ p [] [ text "Select the category to which to add the question:" ]
        , Select.from roomList (UpdateQuestionForm "subject")
        , small [] [ text (Forms.errorString form "subject") ]
        ]


listRooms : WebData RoomsData -> List String
listRooms result =
    case result of
        RemoteData.Success roomsData ->
            "--pick a category--" :: List.map (\room -> room.name) roomsData.data

        _ ->
            []



-- category form section


categoryNameFormElement : Forms.Form -> Html Msg
categoryNameFormElement form =
    div []
        [ p [] [ text "Enter category name bellow, should be uppercase:" ]
        , input
            [ placeholder "for instance: History or Famous people"
            , onInput (UpdateCategoryForm "name")
            , value (Forms.formValue form "name")
            ]
            []
        , small [] [ text (Forms.errorString form "name") ]
        ]
