module Select.Select.Menu exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, style)
import Select.Config exposing (Config)
import Select.Messages exposing (..)
import Select.Models as Models exposing (State)
import Select.Search as Search
import Select.Select.Item as Item
import Select.Styles as Styles
import Select.Utils as Utils


view : Config msg item -> State -> Maybe (List item) -> Html msg
view config state maybeMatchedItems =
    case maybeMatchedItems of
        Nothing ->
            text ""

        Just matchedItems ->
            menu config state matchedItems


menu : Config msg item -> State -> List item -> Html msg
menu config state matchedItems =
    let
        hideWhenNotFound =
            config.notFoundShown == False && matchedItems == []

        menuStyles =
            if hideWhenNotFound then
                Styles.hiddenMenuStyles
                    |> List.map (\( f, s ) -> style f s)

            else
                []

        noResultElement =
            if matchedItems == [] then
                Item.viewNotFound config

            else
                text ""

        itemCount =
            List.length matchedItems

        elements =
            matchedItems
                |> List.indexedMap (Item.view config state itemCount)
    in
    div
        ([ class Styles.menuClass ]
            ++ menuStyles
            ++ config.menuAttrs
        )
        (noResultElement :: elements)
