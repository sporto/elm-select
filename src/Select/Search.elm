module Select.Search exposing (..)

import Fuzzy
import Select.Config exposing (Config)
import Select.Models exposing (State)
import String
import Tuple


type SearchResult item
    = NotSearched
    | ItemsFound (List item)


fuzzyOptions : Config msg item -> List Fuzzy.Config
fuzzyOptions config =
    []
        |> fuzzyAddPenalty config
        |> fuzzyRemovePenalty config
        |> fuzzyMovePenalty config
        |> fuzzyInsertPenalty config


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


fuzzyInsertPenalty config options =
    case config.fuzzySearchInsertPenalty of
        Just penalty ->
            options ++ [ Fuzzy.insertPenalty penalty ]

        _ ->
            options


matchedItemsWithCutoff : Config msg item -> Maybe String -> List item -> SearchResult item
matchedItemsWithCutoff config query items =
    case matchedItems config query items of
        NotSearched ->
            NotSearched

        ItemsFound matching ->
            case config.cutoff of
                Just n ->
                    ItemsFound (List.take n matching)

                Nothing ->
                    ItemsFound matching


matchedItems : Config msg item -> Maybe String -> List item -> SearchResult item
matchedItems config query items =
    let
        maybeQuery : Maybe String
        maybeQuery =
            query
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
