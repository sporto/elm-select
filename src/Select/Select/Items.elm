module Select.Select.Items exposing (..)

import Fuzzy
import Html exposing (..)
import Html.Attributes exposing (class, style)
import Select.Messages as Messages
import Select.Models as Models
import Select.Select.Item
import String
import Tuple


view : Models.Config msg item -> Models.State -> List item -> Maybe item -> Html (Messages.Msg item)
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
                span [] []

            Just query ->
                div [ class config.menuClass, style viewStyles ] (List.map (Select.Select.Item.view config) withCutoff)


viewStyles : List ( String, String )
viewStyles =
    [ ( "position", "absolute" )
    ]


matchedItems : Models.Config msg item -> Models.State -> List item -> List item
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
