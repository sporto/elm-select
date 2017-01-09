module Select.Select.Input exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, value, style)
import Html.Events exposing (on, onInput, onWithOptions)
import Json.Decode as Decode
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

        rootStyles =
            [ ( "position", "relative" ) ]

        inputStyles =
            List.append [ ( "width", "100%" ) ] config.inputStyles

        clearStyles =
            [ ( "position", "absolute" )
            , ( "cursor", "pointer" )
            , ( "right", "0.25rem" )
            , ( "top", "50%" )
            , ( "margin-top", "-0.5rem" )
            ]

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

        onClickWithoutPropagation msg =
            Decode.succeed msg
                |> onWithOptions "click" { stopPropagation = True, preventDefault = False }

        clear =
            span [ onClickWithoutPropagation OnClear, style clearStyles ] [ Clear.view config ]
    in
        div [ class classes, style rootStyles ]
            [ input
                [ onBlurAttribute config model
                , onEsc OnEsc
                , onInput OnQueryChange
                , referenceAttr config model
                , style inputStyles
                , value val
                ]
                []
            , clear
            ]
