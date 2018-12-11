module Select.Select.Menu exposing (menu, view, viewClassAttr, viewStyles)

import Html exposing (..)
import Html.Attributes exposing (class, style)
import Select.Config exposing (Config)
import Select.Messages exposing (..)
import Select.Models as Models exposing (Selected, State)
import Select.Select.Item as Item
import Select.Styles as Styles
import Select.Utils as Utils


view : Config msg item -> State -> List item -> Maybe (Selected item) -> Html (Msg item)
view config model items selected =
    let
        searchResult =
            Search.matchedItemsWithCutoff
    in
    case searchResult of
        Nothing ->
            text ""

        Just matchedItems ->
            menu config model matchedItems


menu : Config msg item -> State -> List item -> Html (Msg item)
menu config model matchedItems =
    let
        hideWhenNotFound =
            config.notFoundShown == False && matchedItems == []

        menuStyle =
            if hideWhenNotFound then
                Styles.hiddenMenuStyles |> List.map (\( f, s ) -> style f s)

            else
                viewStyles config |> List.map (\( f, s ) -> style f s)

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
        (viewClassAttr config :: menuStyle)
        (noResultElement :: elements)


viewClassAttr : Config msg item -> Attribute msg2
viewClassAttr config =
    class (Styles.menuClass ++ config.menuClass)


viewStyles : Config msg item -> List ( String, String )
viewStyles config =
    List.append Styles.visibleMenuStyles config.menuStyles
