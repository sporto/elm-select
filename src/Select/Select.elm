module Select.Select exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, id, style)
import Select.Config exposing (Config)
import Select.Messages exposing (..)
import Select.Models exposing (Selected, State)
import Select.Select.Input
import Select.Select.Menu


view : Config msg item -> State -> List item -> Maybe (Selected item) -> Html (Msg item)
view config model items selected =
    let
        classes =
            "elm-select"

        styles =
            [ ( "position", "relative" ) ]
    in
    div [ id model.id, class classes, style styles ]
        [ Select.Select.Input.view config model items selected
        , Select.Select.Menu.view config model items
        ]
