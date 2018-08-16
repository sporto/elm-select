module Select.Select.Input exposing (..)

import Array
import Html exposing (..)
import Html.Attributes exposing (attribute, autocomplete, class, id, placeholder, style, value)
import Html.Events exposing (keyCode, on, onFocus, onInput, onWithOptions)
import Json.Decode as Decode
import Select.Config exposing (Config)
import Select.Constants as Constants
import Select.Events exposing (onBlurAttribute)
import Select.Messages exposing (..)
import Select.Models as Models exposing (Selected, State)
import Select.Search exposing (matchedItemsWithCutoff)
import Select.Select.Clear as Clear
import Select.Utils as Utils


onKeyPressAttribute : Maybe item -> Attribute (Msg item)
onKeyPressAttribute maybeItem =
    let
        fn code =
            case code of
                9 ->
                    maybeItem
                        |> Maybe.map (Decode.succeed << OnSelect)
                        |> Maybe.withDefault (Decode.fail "nothing selected")

                _ ->
                    Decode.fail "not TAB"
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
                    Decode.succeed (OnSelect item)

        fn code =
            case code of
                13 ->
                    selectItem

                38 ->
                    Decode.succeed OnUpArrow

                40 ->
                    Decode.succeed OnDownArrow

                27 ->
                    Decode.succeed OnEsc

                _ ->
                    Decode.fail "not ENTER"
    in
    on "keyup" (Decode.andThen fn keyCode)


view : Config msg item -> State -> List item -> Maybe (Selected item) -> Html (Msg item)
view config model items selected =
    let
        rootClasses : String
        rootClasses =
            Constants.inputWrapperClass ++ config.inputWrapperClass

        rootStyles : List ( String, String )
        rootStyles =
            List.append
                Constants.inputWrapperStyles
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
                [ Constants.inputClass
                , config.inputClass
                , promptClass
                ]

        inputStyles : List ( String, String )
        inputStyles =
            List.concat
                [ Constants.inputStyles
                , config.inputStyles
                , promptStyles
                , Maybe.withDefault [] <|
                    Utils.andThenSelected selected
                        (\oneSelectedItem -> Just [ ( "width", "100%" ) ])
                        (\manySelectedItems -> Nothing)
                ]

        clearClasses : String
        clearClasses =
            Constants.clearClass ++ config.clearClass

        clearStyles : List ( String, String )
        clearStyles =
            List.append
                Constants.clearStyles
                config.clearStyles

        multiInputClasses : String
        multiInputClasses =
            Constants.multiInputClass ++ config.multiInputClass

        multiInputStyles : List ( String, String )
        multiInputStyles =
            List.append
                Constants.multiInputStyles
                config.multiInputStyles

        multiInputItemContainerClasses : String
        multiInputItemContainerClasses =
            Constants.multiInputItemContainerClass
                ++ config.multiInputItemContainerClass

        multiInputItemContainerStyles : List ( String, String )
        multiInputItemContainerStyles =
            List.append
                Constants.multiInputItemContainerStyles
                config.multiInputItemContainerStyles

        multiInputItemClasses : String
        multiInputItemClasses =
            Constants.multiInputItemClass ++ config.multiInputClass

        multiInputItemStyles : List ( String, String )
        multiInputItemStyles =
            List.append
                Constants.multiInputItemStyles
                config.multiInputStyles

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
                    text ""

                Just _ ->
                    div
                        [ class clearClasses
                        , onClickWithoutPropagation OnClear
                        , style clearStyles
                        ]
                        [ Clear.view config ]

        underlineClasses : String
        underlineClasses =
            Constants.underlineClass ++ config.underlineClass

        underlineStyles : List ( String, String )
        underlineStyles =
            List.append
                Constants.underlineStyles
                config.underlineStyles

        underline : Html (Msg item)
        underline =
            div
                [ class underlineClasses
                , style underlineStyles
                ]
                []

        matchedItems : Select.Search.SearchResult item
        matchedItems =
            matchedItemsWithCutoff config model.query items

        -- item that will be selected if enter if pressed
        preselectedItem : Maybe item
        preselectedItem =
            case matchedItems of
                Select.Search.NotSearched ->
                    Nothing

                Select.Search.ItemsFound [ singleItem ] ->
                    Just singleItem

                Select.Search.ItemsFound found ->
                    case model.highlightedItem of
                        Nothing ->
                            Nothing

                        Just n ->
                            Array.fromList found
                                |> Array.get (rem n (List.length found))

        viewMultiItems : List item -> Html (Msg item)
        viewMultiItems items =
            div
                [ class multiInputItemContainerClasses
                , style multiInputItemContainerStyles
                ]
                (List.map
                    (\item ->
                        span
                            [ class multiInputItemClasses
                            , style multiInputItemStyles
                            ]
                            [ text (config.toLabel item) ]
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
            , onInput OnQueryChange
            , onFocus OnFocus
            , Utils.referenceAttr config model
            , class inputClasses
            , style inputStyles
            ]
    in
    div [ class rootClasses, style rootStyles ]
        [ case ( selected, model.query ) of
            ( Just selectedType, Just queryValue ) ->
                case selectedType of
                    Models.Single item ->
                        input
                            (inputAttributes
                                ++ [ value queryValue ]
                            )
                            []

                    Models.Many items ->
                        div
                            [ class multiInputClasses
                            , style multiInputStyles
                            ]
                            [ viewMultiItems items
                            , input
                                (inputAttributes
                                    ++ [ value queryValue ]
                                )
                                []
                            ]

            ( Just selectedType, Nothing ) ->
                case selectedType of
                    Models.Single item ->
                        input
                            (inputAttributes
                                ++ [ value (config.toLabel item) ]
                            )
                            []

                    Models.Many items ->
                        div
                            [ class multiInputClasses
                            , style multiInputStyles
                            ]
                            [ viewMultiItems items
                            , input
                                (inputAttributes
                                    ++ [ value "" ]
                                )
                                []
                            ]

            ( Nothing, Just queryValue ) ->
                input
                    (inputAttributes
                        ++ [ value queryValue
                           , placeholder config.prompt
                           ]
                    )
                    []

            ( Nothing, Nothing ) ->
                input
                    (inputAttributes
                        ++ [ value ""
                           , placeholder config.prompt
                           ]
                    )
                    []
        , underline
        , clear
        ]
