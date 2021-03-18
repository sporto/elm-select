module Select.Select.Input.Multi exposing (view)

import Html exposing (..)
import Html.Attributes
    exposing
        ( attribute
        , autocomplete
        , class
        , id
        , placeholder
        , style
        , value
        )
import Select.Config exposing (Config)
import Select.Messages as Msg exposing (Msg)
import Select.Models exposing (State)
import Select.Select.RemoveItem as RemoveItem
import Select.Shared as Shared exposing (classNames)


view :
    Config msg item
    -> State
    -> List item
    -> List item
    -> Maybe (List item)
    -> List (Html msg)
view config model availableItems selected maybeMatchedItems =
    let
        val =
            model.query |> Maybe.withDefault ""
    in
    [ currentSelection
        config
        selected
    , input
        (Shared.inputAttributes config model availableItems selected maybeMatchedItems
            ++ [ value val ]
            ++ (if List.isEmpty selected then
                    [ placeholder config.prompt ]

                else
                    []
               )
        )
        []
    ]


currentSelection config selected =
    div
        ([ class classNames.multiInputItemContainer ]
            ++ config.multiInputItemContainerAttrs
        )
        (List.map
            (currentSelection_item config)
            selected
        )


currentSelection_item config item =
    div
        ([ class classNames.multiInputItem ]
            ++ config.multiInputItemAttrs
        )
        [ div
            [ class classNames.multiInputItemText ]
            [ text (config.toLabel item) ]
        , currentSelection_item_maybeClear
            config
            item
        ]


currentSelection_item_maybeClear config item =
    case config.onRemoveItem of
        Nothing ->
            text ""

        Just _ ->
            currentSelection_item_clear
                config
                item


currentSelection_item_clear config item =
    div
        [ class classNames.multiInputItemRemove
        , Shared.onClickWithoutPropagation (Msg.OnRemoveItem item)
            |> Html.Attributes.map config.toMsg
        ]
        [ RemoveItem.view config ]
