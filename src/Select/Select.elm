module Select.Select exposing (..)

import Fuzzy
import Html exposing (..)
import Select.Messages as Messages
import Select.Models as Models
import Select.Select.Option
import Select.Select.Input
import String
import Tuple


view : Models.Config msg item -> Models.Model -> List item -> Maybe item -> Html (Messages.Msg item)
view config model items selected =
    let
        relevantItems =
            matchedItems config model items
    in
        div []
            [ div [] [ Select.Select.Input.view config model selected ]
            , div [] (List.map (Select.Select.Option.view config) relevantItems)
            ]


matchedItems : Models.Config msg item -> Models.Model -> List item -> List item
matchedItems config model items =
    case model.query of
        Nothing ->
            items

        Just query ->
            let
                scoreFor item =
                    Fuzzy.match [] [] (String.toLower query) (String.toLower (config.toLabel item))
                        |> .score
            in
                items
                    |> List.map (\item -> ( scoreFor item, item ))
                    |> List.filter (\( score, item ) -> score < 100)
                    |> List.sortBy Tuple.first
                    |> List.map Tuple.second
