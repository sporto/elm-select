module Select.Select.Menu exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, style)
import Select.Messages exposing (..)
import Select.Models exposing (..)
import Select.Select.Item as Item
import Select.Utils as Utils


view : Config msg item -> State -> List item -> Maybe item -> Html (Msg item)
view config model items selected =
    let
        relevantItems =
            Utils.matchedItems config model items

        withCutoff =
            case config.cutoff of
                Just n ->
                    List.take n relevantItems

                Nothing ->
                    relevantItems

        elements =
            withCutoff
                |> List.map (Item.view config model)

        noResultElement =
            if relevantItems == [] then
                Item.viewNotFound config
            else
                text ""

        -- Treat Nothing and "" as empty query
        query =
            model.query
                |> Maybe.withDefault ""

        menu =
            div
                [ viewClassAttr config
                , style (viewStyles config)
                ]
                (noResultElement :: elements)
    in
        if query == "" then
            text ""
        else
            menu


viewClassAttr : Config msg item -> Attribute msg2
viewClassAttr config =
    class ("elm-select-menu " ++ config.menuClass)


viewStyles : Config msg item -> List ( String, String )
viewStyles config =
    List.append [ ( "position", "absolute" ), ( "z-index", "1" ) ] config.menuStyles
