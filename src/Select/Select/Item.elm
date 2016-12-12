module Select.Select.Item exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, tabindex)
import Html.Events exposing (onClick, on, keyCode)
import Json.Decode as Json
import Select.Messages as Messages
import Select.Models as Models


onKeyUpAttribute : item -> Attribute (Messages.Msg item)
onKeyUpAttribute item =
    let
        fn code =
            case code of
                13 ->
                    Json.succeed (Messages.OnSelect item)

                32 ->
                    Json.succeed (Messages.OnSelect item)

                27 ->
                    Json.succeed Messages.OnEsc

                _ ->
                    Json.fail "not ENTER"
    in
        on "keyup" (Json.andThen fn keyCode)


view : Models.Config msg item -> item -> Html (Messages.Msg item)
view config item =
    div
        [ class config.itemClass
        , onKeyUpAttribute item
        , onClick (Messages.OnSelect item)
        , tabindex 0
        ]
        [ text (config.toLabel item)
        ]
