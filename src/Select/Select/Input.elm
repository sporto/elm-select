module Select.Select.Input exposing (..)

import Array
import Html exposing (..)
import Html.Attributes exposing (attribute, autocomplete, class, id, placeholder, style, value)
import Html.Events exposing (keyCode, on, onFocus, onInput, onWithOptions)
import Json.Decode as Decode
import Select.Config exposing (Config)
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
            "elm-select-input-wrapper " ++ config.inputWrapperClass

        rootStyles : List ( String, String )
        rootStyles =
            List.append
                [ ( "position", "relative" )
                , ( "background", "white" )
                ]
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
                [ "elm-select-input"
                , config.inputClass
                , promptClass
                ]

        inputStyles : List ( String, String )
        inputStyles =
            List.concat
                [ [ ( "outline", "none" )
                  , ( "border", "none" )
                  , ( "display", "inline-block" )
                  ]
                , config.inputStyles
                , promptStyles
                , Maybe.withDefault [] <|
                    Utils.andThenSelected selected
                        (\_ -> Just [ ( "width", "100%" ) ])
                        (\_ -> Nothing)
                ]

        clearClasses : String
        clearClasses =
            "elm-select-clear " ++ config.clearClass

        clearStyles : List ( String, String )
        clearStyles =
            List.append
                [ ( "cursor", "pointer" )
                , ( "height", "1rem" )
                , ( "line-height", "0rem" )
                , ( "margin-top", "-0.5rem" )
                , ( "position", "absolute" )
                , ( "right", "0.25rem" )
                , ( "top", "50%" )
                ]
                config.clearStyles

        multiInputClasses : String
        multiInputClasses =
            "elm-select-multi-input " ++ config.multiInputClass

        multiInputStyles : List ( String, String )
        multiInputStyles =
            List.append [] config.multiInputStyles

        multiInputItemContainerClasses : String
        multiInputItemContainerClasses =
            "elm-select-multiinput-item-container "
                ++ config.multiInputItemContainerClass

        multiInputItemContainerStyles : List ( String, String )
        multiInputItemContainerStyles =
            List.append
                [ ( "display", "inline-block" )
                , ( "padding-left", "0.5rem" )
                ]
                config.multiInputItemContainerStyles

        multiInputItemClasses : String
        multiInputItemClasses =
            "elm-select-multiinput-item " ++ config.multiInputClass

        multiInputItemStyles : List ( String, String )
        multiInputItemStyles =
            List.append
                [ ( "border-style", "solid" )
                , ( "border-width", "0.1rem" )
                , ( "border-radius", "0.1em" )
                , ( "border-color", "#E3E5E8" )
                , ( "background-color", "#E3E5E8" )
                , ( "font-size", ".75rem" )
                , ( "padding-left", ".2rem" )
                , ( "padding-right", ".2rem" )
                , ( "margin-right", ".2rem" )
                ]
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
            "elm-select-underline " ++ config.underlineClass

        underlineStyles : List ( String, String )
        underlineStyles =
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

        -- items wrap around
        idAttribute : List (Attribute (Msg item))
        idAttribute =
            case config.inputId of
                Nothing ->
                    []

                Just inputId ->
                    [ id inputId ]

        inputAttributes =
            [ autocomplete False
            , attribute "autocorrect" "off" -- for mobile Safari
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
                                ++ idAttribute
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
                                    ++ idAttribute
                                    ++ [ value queryValue ]
                                )
                                []
                            ]

            ( Just selectedType, Nothing ) ->
                case selectedType of
                    Models.Single item ->
                        input
                            (inputAttributes
                                ++ idAttribute
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
                                    ++ idAttribute
                                    ++ [ value "" ]
                                )
                                []
                            ]

            ( Nothing, Just queryValue ) ->
                input
                    (inputAttributes
                        ++ idAttribute
                        ++ [ value queryValue
                           , placeholder config.prompt
                           ]
                    )
                    []

            ( Nothing, Nothing ) ->
                input
                    (inputAttributes
                        ++ idAttribute
                        ++ [ value ""
                           , placeholder config.prompt
                           ]
                    )
                    []
        , underline
        , clear
        ]
