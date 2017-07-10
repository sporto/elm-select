module Select.Utils exposing (..)

import Fuzzy
import Html exposing (..)
import Html.Attributes exposing (attribute, class, value)
import Select.Models exposing (..)
import String
import Tuple


type SearchResult item
    = NotSearched
    | ItemsFound (List item)


referenceDataName : String
referenceDataName =
    "data-select-id"


referenceAttr : Config msg item -> State -> Attribute msg2
referenceAttr config model =
    attribute referenceDataName model.id


fuzzyOptions config =
    []
        |> fuzzyAddPenalty config
        |> fuzzyRemovePenalty config
        |> fuzzyMovePenalty config


fuzzyAddPenalty config options =
    case config.fuzzySearchAddPenalty of
        Just penalty ->
            options ++ [ Fuzzy.addPenalty penalty ]

        _ ->
            options


fuzzyRemovePenalty config options =
    case config.fuzzySearchRemovePenalty of
        Just penalty ->
            options ++ [ Fuzzy.removePenalty penalty ]

        _ ->
            options


fuzzyMovePenalty config options =
    case config.fuzzySearchMovePenalty of
        Just penalty ->
            options ++ [ Fuzzy.movePenalty penalty ]

        _ ->
            options


matchedItems : Config msg item -> State -> List item -> SearchResult item
matchedItems config model items =
    let
        maybeQuery : Maybe String
        maybeQuery =
            model.query
                |> Maybe.andThen config.transformQuery
    in
        case maybeQuery of
            Nothing ->
                NotSearched

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
                        |> ItemsFound


scoreForItem : Config msg item -> String -> item -> Int
scoreForItem config query item =
    let
        lowerQuery =
            String.toLower query

        lowerItem =
            config.toLabel item
                |> String.toLower

        options =
            fuzzyOptions config

        fuzzySeparators =
            config.fuzzySearchSeparators
    in
        Fuzzy.match options fuzzySeparators lowerQuery lowerItem
            |> .score
