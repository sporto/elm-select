module Select.Select.Input exposing (onKeyPressAttribute, onKeyUpAttribute, view)

import Array
import Html as Html exposing (Attribute, Html)
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
import Html.Events exposing (keyCode, on, onFocus, onInput, stopPropagationOn)
import Json.Decode as Decode
import Select.Config exposing (Config)
import Select.Events exposing (onBlurAttribute)
import Select.Messages as Msg exposing (Msg)
import Select.Models as Models exposing (State)
import Select.Search as Search
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


view : Config msg item -> State -> List item -> List item -> Html (Msg item)
view config model availableItems selected =
    let
        inputControlClass : String
        inputControlClass =
            Styles.inputControlClass ++ config.inputControlClass

        inputControlStyles : List ( String, String )
        inputControlStyles =
            List.append
                Styles.inputControlStyles
                config.inputControlStyles

        inputControlStylesAttrs =
            Utils.stylesToAttrs inputControlStyles

        inputWrapperClass : String
        inputWrapperClass =
            Styles.inputWrapperClass ++ config.inputWrapperClass

        inputWrapperStyles : List ( String, String )
        inputWrapperStyles =
            List.append
                Styles.inputWrapperStyles
                config.inputWrapperStyles

        inputWrapperStylesAttrs =
            Utils.stylesToAttrs inputWrapperStyles

        clearClasses : String
        clearClasses =
            Styles.clearClass ++ config.clearClass

        clearStyles : List ( String, String )
        clearStyles =
            List.append
                Styles.clearStyles
                config.clearStyles

        clear : Html (Msg item)
        clear =
            case selected of
                Nothing ->
                    Html.text ""

                Just _ ->
                    Html.div
                        ([ class clearClasses
                         , onClickWithoutPropagation Msg.OnClear
                         ]
                            ++ (clearStyles
                                    |> List.map (\( f, s ) -> style f s)
                               )
                        )
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
                (class underlineClasses
                    :: (underlineStyles |> List.map (\( f, s ) -> style f s))
                )
                []

        input =
            if config.isMultiSelect then
                multiInput
                    config
                    model
                    availableItems
                    selected

            else
                singleInput
                    config
                    model
                    availableItems
                    selected
    in
    Html.div
        ([ class inputControlClass ] ++ inputControlStylesAttrs)
        [ Html.div
            ([ class inputWrapperClass ] ++ inputWrapperStylesAttrs)
            input
        , underline
        , clear
        ]


multiInput : Config msg item -> State -> List item -> List item -> List (Html (Msg item))
multiInput config model availableItems selected =
    let
        multiInputItemContainerClasses : String
        multiInputItemContainerClasses =
            Styles.multiInputItemContainerClass
                ++ config.multiInputItemContainerClass

        multiInputItemContainerStyles : List ( String, String )
        multiInputItemContainerStyles =
            List.append
                Styles.multiInputItemContainerStyles
                config.multiInputItemContainerStyles

        multiInputItemContainerStylesAttrs =
            Utils.stylesToAttrs multiInputItemContainerStyles

        multiInputItemClasses : String
        multiInputItemClasses =
            Styles.multiInputItemClass ++ config.multiInputItemClass

        multiInputItemStyles : List ( String, String )
        multiInputItemStyles =
            List.append
                Styles.multiInputItemStyles
                config.multiInputItemStyles

        multiInputItemStylesAttrs =
            Utils.stylesToAttrs multiInputItemStyles

        viewMultiItems : List item -> Html (Msg item)
        viewMultiItems subItems =
            Html.div
                (class multiInputItemContainerClasses
                    :: multiInputItemContainerStylesAttrs
                )
                (List.map
                    (\item ->
                        Html.div
                            (class multiInputItemClasses :: multiInputItemStylesAttrs)
                            [ Html.div (Styles.multiInputItemText |> List.map (\( f, s ) -> style f s)) [ Html.text (config.toLabel item) ]
                            , Maybe.withDefault (Html.span [] []) <|
                                Maybe.map
                                    (\_ ->
                                        Html.div
                                            (onClickWithoutPropagation (Msg.OnRemoveItem item)
                                                :: (Styles.multiInputRemoveItem
                                                        |> List.map (\( f, s ) -> style f s)
                                                   )
                                            )
                                            [ RemoveItem.view config ]
                                    )
                                    config.onRemoveItem
                            ]
                    )
                    subItems
                )
    in
    [ viewMultiItems selected
    , Html.input
        (inputAttributes config model selected ++ [ value model.query ])
        []
    ]


singleInput : Config msg item -> State -> List item -> List item -> List (Html (Msg item))
singleInput config model availableItems selected =
    [ Html.div [] []
    , Html.input
        (inputAttributes config model availableItems selected ++ [ value model.query, placeholder config.prompt ])
        []
    ]


inputAttributes : Config msg item -> State -> List item -> List item -> List (Html.Attribute (Msg item))
inputAttributes config model availableItems selectedItems =
    let
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

        ( promptClass, promptStyles ) =
            if List.isEmpty selectedItems then
                ( config.promptClass, config.promptStyles )

            else
                ( "", [] )

        inputStylesAttrs =
            Utils.stylesToAttrs inputStyles

        matchedItems : Maybe (List item)
        matchedItems =
            Search.matchedItemsWithCutoff
                config
                model.query
                availableItems
                selectedItems

        -- item that will be selected if enter if pressed
        preselectedItem : Maybe item
        preselectedItem =
            case matchedItems of
                Nothing ->
                    Nothing

                Just [ singleItem ] ->
                    Just singleItem

                Just ((head :: rest) as found) ->
                    case model.highlightedItem of
                        Nothing ->
                            Just head

                        Just n ->
                            Array.fromList found
                                |> Array.get (remainderBy (List.length found) n)
    in
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
    ]
        ++ inputStylesAttrs


onClickWithoutPropagation : Msg item -> Attribute (Msg item)
onClickWithoutPropagation msg =
    Decode.succeed ( msg, False )
        |> stopPropagationOn "click"
