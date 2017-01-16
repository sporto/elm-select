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
        rootClasses =
            "elm-select-input-wrapper " ++ config.inputWrapperClass

        rootStyles =
            List.append [ ( "position", "relative" ) ] config.inputWrapperStyles

        inputClasses =
            "elm-select-input " ++ config.inputClass

        inputStyles =
            List.append [ ( "width", "100%" ) ] config.inputStyles

        clearClasses =
            "elm-select-clear " ++ config.clearClass

        clearStyles =
            List.append
                [ ( "cursor", "pointer" )
                , ( "height", "1rem" )
                , ( "line-height", "0rem" )
                , ( "margin-top", "-0.5rem" )
                , ( "position", "absolute" )
                , ( "right", "0.25rem" )
                , ( "top", "50%" )
                ]
                config.clearStyles

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
            case selected of
                Nothing ->
                    text ""
                
                Just _ ->
                    div
                        [ class clearClasses
                        , onClickWithoutPropagation OnClear
                        , style clearStyles
                        ]
                        [ Clear.view config ]

    in
        div [ class rootClasses, style rootStyles ]
            [ input
                [ class inputClasses
                , onBlurAttribute config model
                , onEsc OnEsc
                , onInput OnQueryChange
                , referenceAttr config model
                , style inputStyles
                , value val
                ]
                []
            , clear
            ]
