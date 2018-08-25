module Select.Search exposing (SearchResult(..), matchedItems, matchedItemsWithCutoff, scoreForItem)

import Fuzzy
import Select.Config exposing (Config, fuzzyOptions)
import String
import Tuple


type SearchResult item
    = NotSearched
    | ItemsFound (List item)


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
            case config.fuzzyMatching of
                True ->
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

                False ->
                    ItemsFound items


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
