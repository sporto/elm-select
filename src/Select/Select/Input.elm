module Select.Select.Input exposing (view)

import Html exposing (..)
import Html.Attributes
    exposing
        ( class
        , placeholder
        , value
        )
import Select.Config exposing (Config)
import Select.Messages as Msg exposing (Msg)
import Select.Models exposing (State)
import Select.Select.Clear as Clear
import Select.Select.Input.Multi as Multi
import Select.Shared as Shared exposing (classNames)


view : Config msg item -> State -> List item -> List item -> Maybe (List item) -> Html msg
view config model availableItems selectedItems maybeMatchedItems =
    let
        maybeClear : Html msg
        maybeClear =
            if List.isEmpty selectedItems || config.hasClear == False then
                text ""

            else
                clear config

        input =
            if config.isMultiSelect then
                Multi.view
                    config
                    model
                    availableItems
                    selectedItems
                    maybeMatchedItems

            else
                singleInput
                    config
                    model
                    availableItems
                    selectedItems
                    maybeMatchedItems
    in
    div
        ([ class classNames.inputWrapper ]
            ++ config.inputWrapperAttrs
        )
        (input ++ [ maybeClear ])


clear config =
    div
        ([ class classNames.clear
         , Shared.onClickWithoutPropagation Msg.OnClear
            |> Html.Attributes.map config.toMsg
         ]
            ++ config.clearAttrs
        )
        [ Clear.view config ]


singleInput :
    Config msg item
    -> State
    -> List item
    -> List item
    -> Maybe (List item)
    -> List (Html msg)
singleInput config model availableItems selectedItems maybeMatchedItems =
    let
        val =
            case model.query of
                Nothing ->
                    selectedItems
                        |> List.head
                        |> Maybe.map config.toLabel
                        |> Maybe.withDefault ""

                Just query ->
                    query
    in
    [ input
        (Shared.inputAttributes config model availableItems selectedItems maybeMatchedItems ++ [ value val, placeholder config.prompt ])
        []
    ]
