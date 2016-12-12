module Select.Select.Item exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, style, tabindex)
import Html.Events exposing (onClick, on, keyCode)
import Json.Decode as Json
import Select.Messages exposing (..)
import Select.Models exposing (..)


onKeyUpAttribute : item -> Attribute (Msg item)
onKeyUpAttribute item =
    let
        fn code =
            case code of
                13 ->
                    Json.succeed (OnSelect item)

                32 ->
                    Json.succeed (OnSelect item)

                27 ->
                    Json.succeed OnEsc

                _ ->
                    Json.fail "not ENTER"
    in
        on "keyup" (Json.andThen fn keyCode)


view : Config msg item -> item -> Html (Msg item)
view config item =
    div
        [ class config.itemClass
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
