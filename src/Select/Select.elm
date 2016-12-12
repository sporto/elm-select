module Select.Select exposing (..)

import Html exposing (..)
import Html.Events exposing (onBlur)
import Select.Messages exposing (..)
import Select.Models exposing (..)
import Select.Select.Items
import Select.Select.Input


view : Config msg item -> State -> List item -> Maybe item -> Html (Msg item)
view config model items selected =
    div []
        [ div [] [ Select.Select.Input.view config model selected ]
        , div [] [ Select.Select.Items.view config model items selected ]
        ]
