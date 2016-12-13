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
    div
        [ onBlurAttribute config state
        , onClick (OnSelect item)
        , onKeyUpAttribute item
        , referenceAttr config state
        , style (viewStyles config item)
        , tabindex 0
        , viewClassAttr config
        ]
        [ text (config.toLabel item)
        ]


viewClassAttr : Config msg item -> Attribute msg2
viewClassAttr config =
    class ("elm-select-item " ++ config.itemClass)


viewStyles : Config msg item -> item -> List ( String, String )
viewStyles config item =
    [ ( "cursor", "pointer" ) ]
