module Select.Search exposing
    ( filterItems
    , matchedItemsWithCutoff
    )

import Select.Config exposing (Config)
import Select.Shared as Shared


{-| If config.filter returns Nothing,
then no search has been done and we shouldn't show the menu.
-}
matchedItemsWithCutoff : Config msg item -> Maybe String -> List item -> List item -> Maybe (List item)
matchedItemsWithCutoff config maybeQuery availableItems selectedItems =
    case maybeQuery of
        Nothing ->
            Nothing

        {- When emptySearch is On, onBlur will set query to Just "" -}
        Just "" ->
            if config.emptySearch then
                filterSelectedItemsWhenMulti
                    config
                    availableItems
                    selectedItems
                    |> maybeCuttoff config
                    |> Just

            else
                Nothing

        Just query ->
            filterSelectedItemsWhenMulti
                config
                availableItems
                selectedItems
                |> filterItems
                    { filter = config.filter
                    , query = query
                    , toLabel = config.toLabel
                    , valueSeparators = config.valueSeparators
                    }
                |> Maybe.map (maybeCuttoff config)


type alias FilterArgs item =
    { filter : String -> List item -> Maybe (List item)
    , query : String
    , toLabel : item -> String
    , valueSeparators : List String
    }


{-| If the users types multiple values in the query
e.g. Apple, Banana
We want to search for each of those (not the combined string)
-}
filterItems : FilterArgs item -> List item -> Maybe (List item)
filterItems args items =
    let
        queries =
            Shared.splitWithSeparators args.valueSeparators args.query

        results =
            queries
                |> List.map (\query_ -> args.filter query_ items)
    in
    if List.all ((==) Nothing) results then
        Nothing

    else
        results
            |> List.filterMap identity
            |> List.concat
            |> Shared.uniqueBy args.toLabel
            |> Just


{-| If this is a multi select, then we don't want to display the selected items
in the menu.

So filter these out.

-}
filterSelectedItemsWhenMulti : Config msg item -> List item -> List item -> List item
filterSelectedItemsWhenMulti config availableItems selectedItems =
    if config.isMultiSelect then
        Shared.difference
            availableItems
            selectedItems

    else
        availableItems


maybeCuttoff : Config msg item -> List item -> List item
maybeCuttoff config items =
    case config.cutoff of
        Just cutoff ->
            List.take cutoff items

        Nothing ->
            items
