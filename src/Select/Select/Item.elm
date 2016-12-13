module Select.Select.Item exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, style, tabindex)
import Html.Events exposing (onClick, on, keyCode)
import Json.Decode as Decode
import Select.Events exposing (onBlurAttribute)
import Select.Messages exposing (..)
import Select.Models exposing (..)


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


view : Config msg item -> item -> Html (Msg item)
view config item =
    div
        [ attribute "data-select" "true"
        , class config.itemClass
        , onBlurAttribute
        , onKeyUpAttribute item
        , onClick (OnSelect item)
        , style (viewStyles config item)
        , tabindex 0
        ]
        [ text (config.toLabel item)
        ]


viewStyles : Config msg item -> item -> List ( String, String )
viewStyles config item =
    [ ( "cursor", "pointer" ) ]
