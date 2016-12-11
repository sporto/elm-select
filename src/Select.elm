module Select exposing (..)

import Html exposing (..)
import Html.Events exposing (onInput)
import Select.Option
import Select.Models exposing (Config)


type alias Config msg item =
    Select.Models.Config msg item


view : Config msg item -> List item -> Html msg
view config options =
    div []
        [ div [ onInput config.onQueryChange ] [ input [] [] ]
        , div [] (List.map (Select.Option.view config) options)
        ]
