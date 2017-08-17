module Select.Events exposing (..)

import Html exposing (..)
import Html.Events exposing (on, keyCode)
import Json.Decode as Decode
import Select.Messages exposing (..)
import Select.Models exposing (..)
import Select.Utils exposing (referenceDataName)


traceDecoder : String -> Decode.Decoder msg -> Decode.Decoder msg
traceDecoder message decoder =
    let
        log value =
            case Decode.decodeValue decoder value of
                Ok decoded ->
                    decoded |> Decode.succeed

                Err err ->
                    err |> Debug.log message |> Decode.fail
    in
        Decode.value
            |> Decode.andThen log


onBlurAttribute : Config msg item -> State -> Attribute (Msg item)
onBlurAttribute config state =
    let
        dataDecoder =
            Decode.at [ "relatedTarget", "attributes", referenceDataName, "value" ] Decode.string

        attrToMsg attr =
            if attr == state.id then
                NoOp
            else
                OnBlur

        blur =
            Decode.maybe dataDecoder
                |> Decode.map (Maybe.map attrToMsg)
                |> Decode.map (Maybe.withDefault OnBlur)
    in
        on "focusout" blur
