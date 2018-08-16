module Select.Select.Menu exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, style)
import Select.Config exposing (Config)
import Select.Constants as Constants
import Select.Messages exposing (..)
import Select.Models as Models exposing (Selected, State)
import Select.Search as Search
import Select.Select.Item as Item
import Select.Utils as Utils


view : Config msg item -> State -> List item -> Maybe (Selected item) -> Html (Msg item)
view config model items selected =
    let
        -- Treat Nothing and "" as empty query
        query =
            model.query
                |> Maybe.withDefault ""

        filteredItems =
            Maybe.withDefault items <|
                Utils.andThenSelected selected
                    (\oneSelectedItem -> Nothing)
                    (\manySelectedItems ->
                        Just (Utils.difference items manySelectedItems)
                    )

        searchResult =
            Search.matchedItemsWithCutoff config model.query filteredItems
    in
    if query == "" && not config.emptySearch then
        text ""
    else
        case searchResult of
            Search.NotSearched ->
                text ""

            Search.ItemsFound matchedItems ->
                menu config model matchedItems


menu : Config msg item -> State -> List item -> Html (Msg item)
menu config model matchedItems =
    let
        hideWhenNotFound =
            config.notFoundShown == False && matchedItems == []

        menuStyle =
            if hideWhenNotFound then
                style Constants.hiddenMenuStyles
            else
                style (viewStyles config)

        noResultElement =
            if matchedItems == [] then
                Item.viewNotFound config
            else
                text ""

        itemCount =
            List.length matchedItems

        elements =
            matchedItems
                |> List.indexedMap (Item.view config model itemCount)
    in
    div
        [ viewClassAttr config
        , menuStyle
        ]
        (noResultElement :: elements)


viewClassAttr : Config msg item -> Attribute msg2
viewClassAttr config =
    class (Constants.menuClass ++ config.menuClass)


viewStyles : Config msg item -> List ( String, String )
viewStyles config =
    List.append Constants.visibleMenuStyles config.menuStyles
