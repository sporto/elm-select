module Select.Select.Input exposing (onKeyPressAttribute, onKeyUpAttribute, view)

import Array
import Html as Html exposing (Attribute, Html, div)
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
import Html.Events exposing (keyCode, onFocus, onInput, preventDefaultOn, stopPropagationOn)
import Json.Decode as Decode
import Select.Config exposing (Config)
import Select.Events exposing (onBlurAttribute)
import Select.Messages as Msg exposing (Msg)
import Select.Models exposing (State)
import Select.Select.Clear as Clear
import Select.Select.RemoveItem as RemoveItem
import Select.Shared as Utils exposing (classNames)


onKeyPressAttribute : Maybe item -> Attribute (Msg item)
onKeyPressAttribute maybeItem =
    let
        fn code =
            case code of
                -- Tab
                9 ->
                    maybeItem
                        |> Maybe.map (Decode.succeed << Msg.OnSelect)
                        |> Maybe.withDefault (Decode.fail "nothing selected")

                -- Enter
                13 ->
                    maybeItem
                        |> Maybe.map (Decode.succeed << Msg.OnSelect)
                        |> Maybe.withDefault (Decode.fail "nothing selected")

                _ ->
                    Decode.fail "not TAB or ENTER"
    in
    preventDefaultOn "keypress"
        (Decode.andThen fn keyCode
            |> Decode.map (\msg -> ( msg, True ))
        )


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
    preventDefaultOn "keyup"
        (Decode.andThen fn keyCode
            |> Decode.map (\msg -> ( msg, True ))
        )


view : Config msg item -> State -> List item -> List item -> Maybe (List item) -> Html msg
view config model availableItems selectedItems maybeMatchedItems =
    let
        clear : Html msg
        clear =
            if List.isEmpty selectedItems || config.hasClear == False then
                Html.text ""

            else
                Html.div
                    ([ class classNames.clear
                     , onClickWithoutPropagation Msg.OnClear
                        |> Html.Attributes.map config.toMsg
                     ]
                        ++ config.clearAttrs
                    )
                    [ Clear.view config ]

        input =
            if config.isMultiSelect then
                multiInput
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
        ([ class classNames.inputControl ]
            ++ config.inputControlAttrs
        )
        [ div
            ([ class classNames.inputWrapper ]
                ++ config.inputWrapperAttrs
            )
            input
        , clear
        ]


multiInput : Config msg item -> State -> List item -> List item -> Maybe (List item) -> List (Html msg)
multiInput config model availableItems selected maybeMatchedItems =
    let
        viewMultiItems : List item -> Html msg
        viewMultiItems subItems =
            div
                ([ class classNames.multiInputItemContainer ]
                    ++ config.multiInputItemContainerAttrs
                )
                (List.map
                    (\item ->
                        Html.div
                            ([ class classNames.multiInputItem ]
                                ++ config.multiInputItemAttrs
                            )
                            [ Html.div
                                [ class classNames.multiInputItemText ]
                                [ Html.text (config.toLabel item) ]
                            , Maybe.withDefault (Html.span [] []) <|
                                Maybe.map
                                    (\_ ->
                                        Html.div
                                            [ class classNames.multiInputItemRemove
                                            , onClickWithoutPropagation (Msg.OnRemoveItem item)
                                                |> Html.Attributes.map config.toMsg
                                            ]
                                            [ RemoveItem.view config ]
                                    )
                                    config.onRemoveItem
                            ]
                    )
                    subItems
                )

        val =
            model.query |> Maybe.withDefault ""
    in
    [ viewMultiItems selected
    , Html.input
        (inputAttributes config model availableItems selected maybeMatchedItems
            ++ [ value val ]
            ++ (if List.isEmpty selected then
                    [ placeholder config.prompt ]

                else
                    []
               )
        )
        []
    ]


singleInput : Config msg item -> State -> List item -> List item -> Maybe (List item) -> List (Html msg)
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
    [ Html.div [] []
    , Html.input
        (inputAttributes config model availableItems selectedItems maybeMatchedItems ++ [ value val, placeholder config.prompt ])
        []
    ]


inputAttributes : Config msg item -> State -> List item -> List item -> Maybe (List item) -> List (Html.Attribute msg)
inputAttributes config model availableItems selectedItems maybeMatchedItems =
    let
        promptAttrs =
            if List.isEmpty selectedItems then
                config.promptAttrs

            else
                []

        -- item that will be selected if enter if pressed
        preselectedItem : Maybe item
        preselectedItem =
            case maybeMatchedItems of
                Nothing ->
                    Nothing

                Just matchedItems ->
                    case model.highlightedItem of
                        Nothing ->
                            List.head matchedItems

                        Just n ->
                            Array.fromList matchedItems
                                |> Array.get (remainderBy (List.length matchedItems) n)
    in
    [ autocomplete False
    , attribute "autocorrect" "off" -- for mobile Safari
    , onBlurAttribute config model |> Html.Attributes.map config.toMsg
    , onKeyUpAttribute preselectedItem |> Html.Attributes.map config.toMsg
    , onKeyPressAttribute preselectedItem |> Html.Attributes.map config.toMsg
    , onInput Msg.OnQueryChange |> Html.Attributes.map config.toMsg
    , onFocus Msg.OnFocus |> Html.Attributes.map config.toMsg
    , Utils.referenceAttr config model
    ]
        ++ [ class classNames.input ]
        ++ config.inputAttrs
        ++ promptAttrs


onClickWithoutPropagation : Msg item -> Attribute (Msg item)
onClickWithoutPropagation msg =
    Decode.succeed ( msg, False )
        |> stopPropagationOn "click"
