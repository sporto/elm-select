module Select.Select exposing (..)

import Html exposing (..)
import Html.Attributes exposing (value)
import Html.Events exposing (onInput)
import Select.Models as Models
import Select.Messages as Messages
import Select.Option


view : Models.Config msg item -> Models.Model item -> List item -> Html (Messages.Msg item)
view config model options =
    div []
        [ div
            [ onInput Messages.OnQueryChange
            ]
            [ input [ value model.query ] []
            ]
        , div [] (List.map (Select.Option.view config) options)
        ]
