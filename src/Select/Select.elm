module Select.Select exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, id, style)
import Select.Config exposing (Config)
import Select.Messages exposing (..)
import Select.Models exposing (State)
import Select.Search as Search
import Select.Select.Input
import Select.Select.Menu


view : Config msg item -> State -> List item -> List item -> Html (Msg item)
view config state availableItems selectedItems =
    let
        classes =
            "elm-select"

        availableItemsWithCustom =
            case config.customInput of
                Nothing ->
                    availableItems

                Just fn ->
                    case state.query of
                        Nothing ->
                            availableItems

                        Just query ->
                            if String.isEmpty query then
                                availableItems

                            else
                                let
                                    item =
                                        fn query
                                in
                                item :: availableItems

        -- This is a maybe because
        -- When no search has been done we don't want to show the menu
        -- Which is different from a search that returns empty
        maybeMatchedItems : Maybe (List item)
        maybeMatchedItems =
            Search.matchedItemsWithCutoff
                config
                state.query
                availableItemsWithCustom
                selectedItems
    in
    div
        [ id state.id
        , class classes
        , style "position" "relative"
        ]
        [ Select.Select.Input.view
            config
            state
            availableItems
            selectedItems
            maybeMatchedItems
        , Select.Select.Menu.view
            config
            state
            maybeMatchedItems
        ]
