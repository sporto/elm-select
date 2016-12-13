module Select.Select.Input exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, value)
import Html.Events exposing (on, onInput)
import Select.Events exposing (onEsc, onBlurAttribute)
import Select.Messages exposing (..)
import Select.Models exposing (..)
import Select.Utils exposing (referenceAttr)


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
            [ onBlurAttribute config model
            , onEsc OnEsc
            , onInput OnQueryChange
            , referenceAttr config model
            , value val
            , viewClassAttr config
            ]
            []


viewClassAttr : Config msg item -> Attribute msg2
viewClassAttr config =
    class ("elm-select-input " ++ config.inputClass)
