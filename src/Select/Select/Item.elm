module Select.Select.Item exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, style)
import Html.Events exposing (onMouseDown)
import Select.Config exposing (Config)
import Select.Messages exposing (..)
import Select.Models exposing (State)
import Select.Utils exposing (referenceAttr)
import Select.Constants as Constants


view : Config msg item -> State -> Int -> Int -> item -> Html (Msg item)
view config state itemCount index item =
    let
        ( highlightedItemClass, highlightedItemStyles ) =
            case state.highlightedItem of
                Nothing ->
                    ( "", [] )

                Just highlighted ->
                    -- take remainder as item numbers wrap around
                    if rem highlighted itemCount == index then
                        ( config.highlightedItemClass, config.highlightedItemStyles )
                    else
                        ( "", [] )

        classes =
            String.join " "
                [ baseItemClasses config
                , highlightedItemClass
                ]

        styles =
            List.concat
                [ Constants.menuItemStyles
                , baseItemStyles config
                , highlightedItemStyles
                ]

        itemHtml =
            case config.itemHtml of
                Nothing ->
                    text (config.toLabel item)

                Just fn ->
                    Html.map (\_ -> NoOp) (fn item)
    in
        div
            [ class classes
            , onMouseDown (OnSelect item)
            , referenceAttr config state
            , style styles
            ]
            [ itemHtml
            ]


viewNotFound : Config msg item -> Html (Msg item)
viewNotFound config =
    let
        classes =
            String.join " "
                [ baseItemClasses config
                , config.notFoundClass
                ]

        styles =
            List.append (baseItemStyles config) config.notFoundStyles
    in
        if config.notFound == "" then
            text ""
        else
            div
                [ class classes
                , style styles
                ]
                [ text config.notFound
                ]


baseItemClasses : Config msg item -> String
baseItemClasses config =
    (Constants.menuItemClass ++ config.itemClass)


baseItemStyles : Config msg item -> List ( String, String )
baseItemStyles config =
    config.itemStyles
