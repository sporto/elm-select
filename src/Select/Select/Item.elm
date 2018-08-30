module Select.Select.Item exposing (baseItemClasses, baseItemStyles, view, viewNotFound)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, style)
import Html.Events exposing (onMouseDown)
import Select.Config exposing (Config)
import Select.Messages exposing (..)
import Select.Models exposing (State)
import Select.Styles as Styles
import Select.Utils exposing (referenceAttr)


view : Config msg item -> State -> Int -> Int -> item -> Html (Msg item)
view config state itemCount index item =
    let
        ( highlightedItemClass, highlightedItemStyles ) =
            case state.highlightedItem of
                Nothing ->
                    ( "", [] )

                Just highlighted ->
                    -- take remainder as item numbers wrap around
                    if remainderBy itemCount highlighted == index then
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
                [ Styles.menuItemStyles
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
        ([ class classes
         , onMouseDown (OnSelect item)
         , referenceAttr config state
         ]
            ++ (styles |> List.map (\( f, s ) -> style f s))
        )
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
            (class classes
                :: (styles |> List.map (\( f, s ) -> style f s))
            )
            [ text config.notFound
            ]


baseItemClasses : Config msg item -> String
baseItemClasses config =
    Styles.menuItemClass ++ config.itemClass


baseItemStyles : Config msg item -> List ( String, String )
baseItemStyles config =
    config.itemStyles
