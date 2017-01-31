module Select.Utils exposing (..)

import Fuzzy
import Html exposing (..)
import Html.Attributes exposing (attribute, class, value)
import Select.Models exposing (..)
import String
import Tuple


referenceDataName : String
referenceDataName =
    "data-select-id"


referenceAttr : Config msg item -> State -> Attribute msg2
referenceAttr config model =
    attribute referenceDataName model.id


matchedItems : Config msg item -> State -> List item -> List item
matchedItems config model items =
    case model.query of
        Nothing ->
            items

        Just query ->
            let
                scoreFor =
                    scoreForItem config query
            in
                items
                    |> List.map (\item -> ( scoreFor item, item ))
                    |> List.filter (\( score, item ) -> score < config.scoreThreshold)
                    |> List.sortBy Tuple.first
                    |> List.map Tuple.second


scoreForItem : Config msg item -> String -> item -> Int
scoreForItem config query item =
    let
        lowerQuery =
            String.toLower query

        lowerItem =
            config.toLabel item
                |> String.toLower
    in
        Fuzzy.match [] [] lowerQuery lowerItem
            |> .score
