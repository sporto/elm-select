module Select.Select exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, id, style)
import Select.Messages exposing (..)
import Select.Models exposing (..)
import Select.Select.Menu
import Select.Select.Input


view : Config msg item -> State -> List item -> Maybe item -> Html (Msg item)
view config model items selected =
    let
        classes =
            "elm-select"

        styles =
            [ ( "position", "relative" ) ]
    in
        div [ id model.id, class classes, style styles ]
            [ Select.Select.Input.view config model selected
            , Select.Select.Menu.view config model items selected
            ]
