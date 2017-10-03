module Select.Select.Menu exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, style)
import Select.Messages exposing (..)
import Select.Config exposing (Config)
import Select.Models exposing (State)
import Select.Select.Item as Item
import Select.Search as Search


view : Config msg item -> State -> List item -> Html (Msg item)
view config model items =
    let
        -- Treat Nothing and "" as empty query
        query =
            model.query
                |> Maybe.withDefault ""

        searchResult =
            Search.matchedItemsWithCutoff config model.query items
    in
        if query == "" then
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
                style [ ( "display", "none" ) ]
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
    class ("elm-select-menu " ++ config.menuClass)


viewStyles : Config msg item -> List ( String, String )
viewStyles config =
    List.append [ ( "position", "absolute" ), ( "z-index", "1" ) ] config.menuStyles
