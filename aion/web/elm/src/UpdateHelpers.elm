module UpdateHelpers exposing (..)

import Auth.Models exposing (Token)
import Forms
import General.Models exposing (Model)
import Json.Decode as Decode
import Json.Encode as Encode
import Msgs exposing (Msg)
import Navigation exposing (Location, modifyUrl)
import Panel.Api exposing (fetchCategories)
import Ports exposing (check)
import Room.Api exposing (fetchRooms)
import Urls exposing (host)
import User.Api exposing (fetchCurrentUser)


updateForm : String -> String -> Forms.Form -> Forms.Form
updateForm name value form =
    Forms.updateFormInput form name value


decodeAndUpdate :
    Decode.Value
    -> Decode.Decoder a
    -> Model
    -> (a -> ( Model, Cmd msg ))
    -> ( Model, Cmd msg )
decodeAndUpdate encodedValue decoder model updateFun =
    case Decode.decodeValue decoder encodedValue of
        Ok value ->
            updateFun value

        Err error ->
            model ! []


unwrapToken : Maybe String -> String
unwrapToken token =
    case token of
        Just actualToken ->
            actualToken

        Nothing ->
            ""


setHomeUrl : Location -> Cmd Msg
setHomeUrl location =
    modifyUrl (host location)


postTokenActions : Token -> Location -> List (Cmd Msg)
postTokenActions token location =
    [ check token
    , fetchRooms location token
    , fetchCategories location token
    , fetchCurrentUser location token
    , setHomeUrl location
    ]



-- instead of calling "unwrap token" every time, this function will do it for you


withToken : Model -> (Token -> a) -> a
withToken model command =
    let
        token =
            unwrapToken model.authData.token
    in
        command token



-- instead of passing location you can just pass model to this function


withLocation : Model -> (Location -> a) -> a
withLocation model function =
    let
        location =
            model.location
    in
        function location
