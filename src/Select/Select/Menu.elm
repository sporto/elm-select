module Select.Select.Menu exposing (..)

import Fuzzy
import Html exposing (..)
import Html.Attributes exposing (class, style)
import Select.Messages exposing (..)
import Select.Models exposing (..)
import Select.Select.Item as Item
import String
import Tuple


view : Config msg item -> State -> List item -> Maybe item -> Html (Msg item)
view config model items selected =
    let
        relevantItems =
            matchedItems config model items

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


matchedItems : Config msg item -> State -> List item -> List item
matchedItems config model items =
    case model.query of
        Nothing ->
            items

        Just query ->
            let
                options =
                    []

                options1 =
                    case config.fuzzySearchAddPenalty of
                        Just penalty ->
                            options ++ [ Fuzzy.addPenalty penalty ]

                        _ ->
                            options

                options2 =
                    case config.fuzzySearchRemovePenalty of
                        Just penalty ->
                            options1 ++ [ Fuzzy.removePenalty penalty ]

                        _ ->
                            options1

                options3 =
                    case config.fuzzySearchMovePenalty of
                        Just penalty ->
                            options2 ++ [ Fuzzy.movePenalty penalty ]

                        _ ->
                            options2

                separators =
                    config.fuzzySearchSeparators

                scoreFor item =
                    Fuzzy.match options3 separators (String.toLower query) (String.toLower (config.toLabel item))
                        |> .score
            in
                items
                    |> List.map (\item -> ( scoreFor item, item ))
                    |> List.filter (\( score, item ) -> score < 100)
                    |> List.sortBy Tuple.first
                    |> List.map Tuple.second
