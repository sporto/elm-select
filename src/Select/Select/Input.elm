module Select.Select.Input exposing (..)

import Array
import Html as Html exposing (Attribute, Html)
import Html.Attributes exposing (attribute, autocomplete, class, id, placeholder, style, value)
import Html.Events exposing (keyCode, on, onFocus, onInput, onWithOptions)
import Json.Decode as Decode
import Select.Config exposing (Config)
import Select.Events exposing (onBlurAttribute)
import Select.Messages as Msg exposing (Msg)
import Select.Models as Models exposing (Selected, State)
import Select.Search exposing (matchedItemsWithCutoff)
import Select.Select.Clear as Clear
import Select.Select.RemoveItem as RemoveItem
import Select.Styles as Styles
import Select.Utils as Utils


onKeyPressAttribute : Maybe item -> Attribute (Msg item)
onKeyPressAttribute maybeItem =
    let
        fn code =
            case code of
                9 ->
                    maybeItem
                        |> Maybe.map (Decode.succeed << Msg.OnSelect)
                        |> Maybe.withDefault (Decode.fail "nothing selected")

                13 ->
                    maybeItem
                        |> Maybe.map (Decode.succeed << Msg.OnSelect)
                        |> Maybe.withDefault (Decode.fail "nothing selected")

                _ ->
                    Decode.fail "not TAB or ENTER"
    in
    on "keypress" (Decode.andThen fn keyCode)


onKeyUpAttribute : Maybe item -> Attribute (Msg item)
onKeyUpAttribute maybeItem =
    let
        selectItem =
            case maybeItem of
                Nothing ->
                    Decode.fail "not Enter"

                Just item ->
                    Decode.succeed (Msg.OnSelect item)

        fn code =
            case code of
                13 ->
                    selectItem

                38 ->
                    Decode.succeed Msg.OnUpArrow

                40 ->
                    Decode.succeed Msg.OnDownArrow

                27 ->
                    Decode.succeed Msg.OnEsc

                _ ->
                    Decode.fail "not ENTER"
    in
    on "keyup" (Decode.andThen fn keyCode)


view : Config msg item -> State -> List item -> Maybe (Selected item) -> Html (Msg item)
view config model items selected =
    let
        inputControlClass : String
        inputControlClass =
            Styles.inputControlClass ++ config.inputControlClass

        inputControlStyles : List ( String, String )
        inputControlStyles =
            List.append
                Styles.inputControlStyles
                config.inputControlStyles

        inputWrapperClass : String
        inputWrapperClass =
            Styles.inputWrapperClass ++ config.inputWrapperClass

        inputWrapperStyles : List ( String, String )
        inputWrapperStyles =
            List.append
                Styles.inputWrapperStyles
                config.inputWrapperStyles

        ( promptClass, promptStyles ) =
            case selected of
                Nothing ->
                    ( config.promptClass, config.promptStyles )

                Just _ ->
                    ( "", [] )

        inputClasses : String
        inputClasses =
            String.join " "
                [ Styles.inputClass
                , config.inputClass
                , promptClass
                ]

        inputStyles : List ( String, String )
        inputStyles =
            List.concat
                [ Styles.inputStyles
                , config.inputStyles
                , promptStyles
                ]

        clearClasses : String
        clearClasses =
            Styles.clearClass ++ config.clearClass

        clearStyles : List ( String, String )
        clearStyles =
            List.append
                Styles.clearStyles
                config.clearStyles

        multiInputItemContainerClasses : String
        multiInputItemContainerClasses =
            Styles.multiInputItemContainerClass
                ++ config.multiInputItemContainerClass

        multiInputItemContainerStyles : List ( String, String )
        multiInputItemContainerStyles =
            List.append
                Styles.multiInputItemContainerStyles
                config.multiInputItemContainerStyles

        multiInputItemClasses : String
        multiInputItemClasses =
            Styles.multiInputItemClass ++ config.multiInputItemClass

        multiInputItemStyles : List ( String, String )
        multiInputItemStyles =
            List.append
                Styles.multiInputItemStyles
                config.multiInputItemStyles

        onClickWithoutPropagation : Msg item -> Attribute (Msg item)
        onClickWithoutPropagation msg =
            Decode.succeed msg
                |> onWithOptions "click"
                    { stopPropagation = True
                    , preventDefault = False
                    }

        clear : Html (Msg item)
        clear =
            case selected of
                Nothing ->
                    Html.text ""

                Just _ ->
                    Html.div
                        [ class clearClasses
                        , onClickWithoutPropagation Msg.OnClear
                        , style clearStyles
                        ]
                        [ Clear.view config ]

        underlineClasses : String
        underlineClasses =
            Styles.underlineClass ++ config.underlineClass

        underlineStyles : List ( String, String )
        underlineStyles =
            List.append
                Styles.underlineStyles
                config.underlineStyles

        underline : Html (Msg item)
        underline =
            Html.div
                [ class underlineClasses
                , style underlineStyles
                ]
                []

        filteredItems : List item
        filteredItems =
            Maybe.withDefault items <|
                Utils.andThenSelected selected
                    (\oneSelectedItem -> Nothing)
                    (\manySelectedItems ->
                        Just (Utils.difference items manySelectedItems)
                    )

        matchedItems : Select.Search.SearchResult item
        matchedItems =
            matchedItemsWithCutoff config model.query filteredItems

        -- item that will be selected if enter if pressed
        preselectedItem : Maybe item
        preselectedItem =
            case matchedItems of
                Select.Search.NotSearched ->
                    Nothing

                Select.Search.ItemsFound [] ->
                    Nothing

                Select.Search.ItemsFound [ singleItem ] ->
                    Just singleItem

                Select.Search.ItemsFound ((head :: rest) as found) ->
                    case model.highlightedItem of
                        Nothing ->
                            Just head

                        Just n ->
                            Array.fromList found
                                |> Array.get (rem n (List.length found))

        viewMultiItems : List item -> Html (Msg item)
        viewMultiItems items =
            Html.div
                [ class multiInputItemContainerClasses
                , style multiInputItemContainerStyles
                ]
                (List.map
                    (\item ->
                        Html.div
                            [ class multiInputItemClasses, style multiInputItemStyles ]
                            [ Html.div [ style Styles.multiInputItemText ] [ Html.text (config.toLabel item) ]
                            , Maybe.withDefault (Html.span [] []) <|
                                Maybe.map
                                    (\_ ->
                                        Html.div
                                            [ onClickWithoutPropagation (Msg.OnRemoveItem item)
                                            , style Styles.multiInputRemoveItem
                                            ]
                                            [ RemoveItem.view config ]
                                    )
                                    config.onRemoveItem
                            ]
                    )
                    items
                )

        inputAttributes =
            [ autocomplete False
            , attribute "autocorrect" "off" -- for mobile Safari
            , id config.inputId
            , onBlurAttribute config model
            , onKeyUpAttribute preselectedItem
            , onKeyPressAttribute preselectedItem
            , onInput Msg.OnQueryChange
            , onFocus Msg.OnFocus
            , Utils.referenceAttr config model
            , class inputClasses
            , style inputStyles
            ]
    in
    Html.div [ class inputControlClass, style inputControlStyles ]
        [ Html.div [ class inputWrapperClass, style inputWrapperStyles ] <|
            case ( selected, model.query ) of
                ( Just selectedType, Just queryValue ) ->
                    case selectedType of
                        Models.Single item ->
                            [ Html.div [] []
                            , Html.input
                                (inputAttributes ++ [ value queryValue ])
                                []
                            ]

                        Models.Many items ->
                            [ viewMultiItems items
                            , Html.input
                                (inputAttributes ++ [ value queryValue ])
                                []
                            ]

                ( Just selectedType, Nothing ) ->
                    case selectedType of
                        Models.Single item ->
                            [ Html.div [] []
                            , Html.input
                                (inputAttributes ++ [ value (config.toLabel item) ])
                                []
                            ]

                        Models.Many items ->
                            [ viewMultiItems items
                            , Html.input
                                (inputAttributes ++ [ value "" ])
                                []
                            ]

                ( Nothing, Just queryValue ) ->
                    [ Html.div [] []
                    , Html.input
                        (inputAttributes
                            ++ [ value queryValue
                               , placeholder config.prompt
                               ]
                        )
                        []
                    ]

                ( Nothing, Nothing ) ->
                    [ Html.div [] []
                    , Html.input
                        (inputAttributes
                            ++ [ value ""
                               , placeholder config.prompt
                               ]
                        )
                        []
                    ]
        , underline
        , clear
        ]
