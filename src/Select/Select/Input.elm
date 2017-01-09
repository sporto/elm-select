module Select.Select.Input exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, value, style)
import Html.Events exposing (on, onInput)
import Select.Events exposing (onEsc, onBlurAttribute)
import Select.Messages exposing (..)
import Select.Models exposing (..)
import Select.Select.Clear as Clear
import Select.Utils exposing (referenceAttr)


view : Config msg item -> State -> Maybe item -> Html (Msg item)
view config model selected =
    let
        classes =
            "elm-select-input " ++ config.inputClass

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

        clear =
            Clear.view config
    in
        div [ class classes, style config.inputStyles ]
            [ input
                [ onBlurAttribute config model
                , onEsc OnEsc
                , onInput OnQueryChange
                , referenceAttr config model
                , value val
                ]
                []
            , clear
            , clear
            ]
