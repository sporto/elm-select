module Select.Search exposing (matchedItemsWithCutoff)

import Select.Config exposing (Config)
import Select.Utils as Utils


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
                filterItems config availableItems selectedItems
                    |> maybeCuttoff config
                    |> Just

            else
                Nothing

        Just query ->
            filterItems config availableItems selectedItems
                |> config.filter query
                |> Maybe.map (maybeCuttoff config)


{-| If this is a multi select, then we don't want to display the selected items
in the menu.

So filter these out.

-}
filterItems : Config msg item -> List item -> List item -> List item
filterItems config availableItems selectedItems =
    if config.isMultiSelect then
        Utils.difference
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
