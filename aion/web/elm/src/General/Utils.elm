module General.Utils exposing (..)

import Array exposing (Array, fromList)
import General.Models exposing (Model)
import Json.Decode as Decode


roomsViewColorList : Array String
roomsViewColorList =
    fromList [ "#1abc9c", "#2ecc71", "#9b59b6", "#34495e", "#f1c40f", "#e74c3c", "#d35400" ]


roomsDefaultColor : String
roomsDefaultColor =
    "#1abc9c"


sliceList : Int -> List a -> List (List a)
sliceList n list =
    case ( n, list ) of
        ( 0, list ) ->
            [ list ]

        ( n, [] ) ->
            []

        ( n, list ) ->
            (List.take n list) :: (sliceList n (List.drop n list))


withUnpackRaw :
    Decode.Value
    -> Decode.Decoder a
    -> Model
    -> (a -> ( Model, Cmd msg ))
    -> ( Model, Cmd msg )
withUnpackRaw raw decoder model fun =
    case Decode.decodeValue decoder raw of
        Ok value ->
            fun value

        Err error ->
            model ! []
