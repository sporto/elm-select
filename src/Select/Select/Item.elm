module Select.Select.Item exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, style, tabindex)
import Html.Events exposing (onClick, on, keyCode)
import Json.Decode as Decode
import Select.Events exposing (onBlurAttribute)
import Select.Messages exposing (..)
import Select.Models exposing (..)
import Select.Utils exposing (referenceAttr)


onKeyUpAttribute : item -> Attribute (Msg item)
onKeyUpAttribute item =
    let
        fn code =
            case code of
                13 ->
                    Decode.succeed (OnSelect item)

                32 ->
                    Decode.succeed (OnSelect item)

                27 ->
                    Decode.succeed OnEsc

                _ ->
                    Decode.fail "not ENTER"
    in
        on "keyup" (Decode.andThen fn keyCode)


view : Config msg item -> State -> item -> Html (Msg item)
view config state item =
    let
        classes =
            baseItemClasses config

        styles =
            ( "cursor", "pointer" ) :: (baseItemStyles config)
    in
        div
            [ class classes
            , onBlurAttribute config state
            , onClick (OnSelect item)
            , onKeyUpAttribute item
            , referenceAttr config state
            , style styles
            , tabindex 0
            ]
            [ text (config.toLabel item)
            ]


viewNotFound : Config msg item -> Html (Msg item)
viewNotFound config =
    let
        classes =
            String.join " "
                [ baseItemClasses config
                , config.notFoundClass
                ]

        styles =
            List.append (baseItemStyles config) config.notFoundStyles
    in
        if config.notFound == "" then
            text ""
        else
            div
                [ class classes
                , style styles
                ]
                [ text config.notFound
                ]


baseItemClasses : Config msg item -> String
baseItemClasses config =
    ("elm-select-item " ++ config.itemClass)


baseItemStyles : Config msg item -> List ( String, String )
baseItemStyles config =
    config.itemStyles
