module Select.Option exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Select.Models exposing (Config)


view : Config msg item -> item -> Html msg
view config item =
    div [ onClick (config.onSelect item) ]
        [ text (config.toLabel item)
        ]
