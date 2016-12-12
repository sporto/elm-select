module Select.Select.Item exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, tabindex)
import Html.Events exposing (onClick, on, keyCode)
import Json.Decode as Json
import Select.Messages as Messages
import Select.Models as Models


onEnter : msg -> Attribute msg
onEnter msg =
    let
        isEnterOrSpace code =
            if code == 13 || code == 32 then
                Json.succeed msg
            else
                Json.fail "not ENTER"
    in
        on "keyup" (Json.andThen isEnterOrSpace keyCode)


view : Models.Config msg item -> item -> Html (Messages.Msg item)
view config item =
    div
        [ class config.itemClass
        , onEnter (Messages.OnSelect item)
        , onClick (Messages.OnSelect item)
        , tabindex 0
        ]
        [ text (config.toLabel item)
        ]
