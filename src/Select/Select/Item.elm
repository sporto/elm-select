module Select.Select.Item exposing
    ( view
    , viewNotFound
    )

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onMouseDown)
import Select.Config exposing (Config)
import Select.Messages exposing (..)
import Select.Models exposing (State)
import Select.Shared exposing (classNames, referenceAttr)


view : Config msg item -> State -> Int -> Int -> item -> Html msg
view config state itemCount index item =
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

        itemHtml =
            case config.itemHtml of
                Nothing ->
                    text (config.toLabel item)

                Just fn ->
                    fn item
    in
    div
        ([ class classNames.menuItem
         , class classNames.menuItemSelectable
         , onMouseDown (config.toMsg (OnSelect item))
         , referenceAttr config state
         ]
            ++ highlightedItemAttrs
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
