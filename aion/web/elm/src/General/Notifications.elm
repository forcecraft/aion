module General.Notifications exposing (..)

import General.Models exposing (Model)
import Html.Attributes exposing (style)
import Msgs exposing (Msg(..))
import Toasty
import Toasty.Defaults


toastsConfig : Toasty.Config Msg
toastsConfig =
    Toasty.Defaults.config
        |> Toasty.delay 5000
        |> Toasty.containerAttrs containerAttrs


addToast : Toasty.Defaults.Toast -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
addToast toast ( model, cmd ) =
    Toasty.addToast toastsConfig ToastyMsg toast ( model, cmd )


containerAttrs =
    [ style
        [ ( "position", "fixed" )
        , ( "top", "0" )
        , ( "right", "0" )
        , ( "width", "100%" )
        , ( "max-width", "300px" )
        , ( "list-style-type", "none" )
        , ( "padding", "0" )
        , ( "margin", "0" )
        , ( "z-index", "5" )
        ]
    ]
