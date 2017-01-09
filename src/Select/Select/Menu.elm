module Select.Select.Menu exposing (..)

import Fuzzy
import Html exposing (..)
import Html.Attributes exposing (class, style)
import Select.Messages exposing (..)
import Select.Models exposing (..)
import Select.Select.Item
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
    in
        case model.query of
            Nothing ->
                text ""

            Just query ->
                div
                    [ viewClassAttr config
                    , style (viewStyles config)
                    ]
                    (List.map (Select.Select.Item.view config model) withCutoff)


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
                scoreFor item =
                    Fuzzy.match [] [] (String.toLower query) (String.toLower (config.toLabel item))
                        |> .score
            in
                items
                    |> List.map (\item -> ( scoreFor item, item ))
                    |> List.filter (\( score, item ) -> score < 100)
                    |> List.sortBy Tuple.first
                    |> List.map Tuple.second
