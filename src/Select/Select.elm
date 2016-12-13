module Select.Select exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, id)
import Select.Messages exposing (..)
import Select.Models exposing (..)
import Select.Select.Items
import Select.Select.Input


view : Config msg item -> State -> List item -> Maybe item -> Html (Msg item)
view config model items selected =
    div [ id model.id, class "elm-select" ]
        [ Select.Select.Input.view config model selected
        , Select.Select.Items.view config model items selected
        ]
