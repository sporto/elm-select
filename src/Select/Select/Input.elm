module Select.Select.Input exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, value)
import Html.Events exposing (on, onInput)
import Select.Events exposing (onEsc, onBlurAttribute)
import Select.Messages exposing (..)
import Select.Models exposing (..)


view : Config msg item -> State -> Maybe item -> Html (Msg item)
view config model selected =
    let
        val =
            case model.query of
                Nothing ->
                    case selected of
                        Nothing ->
                            ""

                        Just item ->
                            config.toLabel item

                Just str ->
                    str
    in
        input
            [ attribute "data-select" "true"
            , class config.inputClass
            , onBlurAttribute
            , onInput OnQueryChange
            , onEsc OnEsc
            , value val
            ]
            []
