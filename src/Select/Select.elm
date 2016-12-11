module Select.Select exposing (..)

import Fuzzy
import Html exposing (..)
import Html.Attributes exposing (value)
import Html.Events exposing (onInput)
import Select.Messages as Messages
import Select.Models as Models
import Select.Option
import String
import Tuple


view : Models.Config msg item -> Models.Model -> List item -> Html (Messages.Msg item)
view config model items =
    let
        relevantItems =
            matchedItems config model items
    in
        div []
            [ div
                [ onInput Messages.OnQueryChange
                ]
                [ input [ value model.query ] []
                ]
            , div [] (List.map (Select.Option.view config) relevantItems)
            ]


matchedItems : Models.Config msg item -> Models.Model -> List item -> List item
matchedItems config model items =
    if model.query == "" then
        []
    else
        let
            scoreFor item =
                Fuzzy.match [] [] (String.toLower model.query) (String.toLower (config.toLabel item))
                    |> .score
        in
            items
                |> List.map (\item -> ( scoreFor item, item ))
                |> List.filter (\( score, item ) -> score < 100)
                |> List.sortBy Tuple.first
                |> List.map Tuple.second
