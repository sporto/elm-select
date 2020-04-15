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


view : Config msg item -> State -> Maybe (List item) -> Html (Msg item)
view config state maybeMatchedItems =
    case maybeMatchedItems of
        Nothing ->
            text ""

        Just matchedItems ->
            menu config state matchedItems


menu : Config msg item -> State -> List item -> Html (Msg item)
menu config state matchedItems =
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
                Item.viewNotFound config state

            else
                text ""

        itemCount =
            List.length matchedItems

        elements =
            matchedItems
                |> List.indexedMap (Item.view config state itemCount)
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
