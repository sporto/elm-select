module Select.Select.Item exposing
    ( view
    , viewNotFound
    )

import Html exposing (..)
import Html.Attributes exposing (attribute, class)
import Html.Events exposing (onMouseDown)
import Select.Config exposing (Config)
import Select.Messages exposing (..)
import Select.Models exposing (State)
import Select.Shared exposing (classNames, referenceAttr)


view : Config msg item -> State -> Int -> List item -> Int -> item -> Html msg
view config state itemCount selectedItems index item =
    let
        highlightedItemAttrs =
            case state.highlightedItem of
                Nothing ->
                    []

                Just highlighted ->
                    -- take remainder as item numbers wrap around
                    if remainderBy itemCount highlighted == index then
                        config.highlightedItemAttrs

                    else
                        []

        selectedAttrs =
            if isSelected then
                config.selectedItemAttrs

            else
                []

        isSelected =
            List.member item selectedItems

        label =
            config.toLabel item

        itemHtml =
            case config.itemHtml of
                Nothing ->
                    text label

                Just fn ->
                    fn item
    in
    div
        ([ class classNames.menuItem
         , class classNames.menuItemSelectable
         , attribute "data-select-item" label
         , onMouseDown (config.toMsg (OnSelect item))
         , referenceAttr config state
         ]
            ++ highlightedItemAttrs
            ++ selectedAttrs
        )
        [ itemHtml
        ]


viewNotFound : Config msg item -> Html msg
viewNotFound config =
    if config.notFound == "" then
        text ""

    else
        div
            ([ class classNames.menuItem ] ++ config.notFoundAttrs)
            [ text config.notFound ]
