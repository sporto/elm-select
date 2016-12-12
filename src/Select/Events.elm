module Select.Events exposing (..)

import Html exposing (..)
import Html.Events exposing (on, keyCode)
import Json.Decode as Json


onEnterOrSpace : msg -> Attribute msg
onEnterOrSpace msg =
    let
        isEnterOrSpace code =
            if code == 13 || code == 32 then
                Json.succeed msg
            else
                Json.fail "not ENTER"
    in
        on "keyup" (Json.andThen isEnterOrSpace keyCode)


onEsc : msg -> Attribute msg
onEsc msg =
    let
        isEsc code =
            if code == 27 then
                Json.succeed msg
            else
                Json.fail "not ENTER"
    in
        on "keyup" (Json.andThen isEsc keyCode)
