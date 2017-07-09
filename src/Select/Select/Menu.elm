module Select.Select.Menu exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, style)
import Select.Messages exposing (..)
import Select.Models exposing (..)
import Select.Select.Item as Item
import Select.Utils as Utils


view : Config msg item -> State -> List item -> Html (Msg item)
view config model items =
    let
        -- Treat Nothing and "" as empty query
        query =
            model.query
                |> Maybe.withDefault ""

        searchResult =
            Utils.matchedItems config model items
    in
        if query == "" then
            text ""
        else
            case searchResult of
                Utils.NotSearched ->
                    text ""

                Utils.ItemsFound matchedItems ->
                    menu config model matchedItems


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

        withCutoff =
            case config.cutoff of
                Just n ->
                    List.take n matchedItems

                Nothing ->
                    matchedItems

        elements =
            withCutoff
                |> List.map (Item.view config model)
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
