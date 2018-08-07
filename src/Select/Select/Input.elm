module Select.Select.Input exposing (..)

import Array
import Html exposing (..)
import Html.Attributes exposing (attribute, autocomplete, class, id, placeholder, style, value)
import Html.Events exposing (keyCode, on, onFocus, onInput, onWithOptions)
import Json.Decode as Decode
import Select.Config exposing (Config)
import Select.Events exposing (onBlurAttribute)
import Select.Messages exposing (..)
import Select.Models exposing (Selected(..), State)
import Select.Search exposing (matchedItemsWithCutoff)
import Select.Select.Clear as Clear
import Select.Utils exposing (referenceAttr)


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
        rootClasses =
            "elm-select-input-wrapper " ++ config.inputWrapperClass

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

        inputClasses =
            String.join " "
                [ "elm-select-input"
                , config.inputClass
                , promptClass
                ]

        inputStyles =
            List.concat
                [ [ ( "width", "100%" )
                  , ( "outline", "none" )
                  , ( "border", "none" )
                  ]
                , config.inputStyles
                , promptStyles
                ]

        clearClasses =
            "elm-select-clear " ++ config.clearClass

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

        multiClasses =
            "elm-select-multi " ++ config.multiClass

        multiStyles =
            List.append
                []
                config.multiStyles

        ( valueAttribute, valueHtml ) =
            case ( selected, model.query ) of
                ( Just selectedType, Just queryValue ) ->
                    case selectedType of
                        Single item ->
                            ( [ value queryValue ], [] )

                        Many items ->
                            ( [ value queryValue ]
                            , [ div [ class multiClasses, style multiStyles ] <|
                                    List.map (config.toLabel >> text) items
                              ]
                            )

                ( Just selectedType, Nothing ) ->
                    case selectedType of
                        Single item ->
                            ( [ value (config.toLabel item) ], [] )

                        Many items ->
                            ( []
                            , [ div [ class multiClasses, style multiStyles ] <|
                                    List.map (config.toLabel >> text) items
                              ]
                            )

                ( Nothing, Just query ) ->
                    ( [ value query ], [] )

                ( Nothing, Nothing ) ->
                    ( [ value "" ], [] )

        onClickWithoutPropagation msg =
            Decode.succeed msg
                |> onWithOptions "click" { stopPropagation = True, preventDefault = False }

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

        underlineClasses =
            "elm-select-underline " ++ config.underlineClass

        underlineStyles =
            config.underlineStyles

        underline =
            div
                [ class underlineClasses
                , style underlineStyles
                ]
                []

        matchedItems =
            matchedItemsWithCutoff config model.query items

        -- item that will be selected if enter if pressed
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
                            Array.fromList found |> Array.get (rem n (List.length found))

        -- items wrap around
        idAttribute =
            case config.inputId of
                Nothing ->
                    []

                Just inputId ->
                    [ id inputId ]
    in
    div [ class rootClasses, style rootStyles ] <|
        List.concat
            [ valueHtml
            , [ input
                    (List.concat
                        [ [ class inputClasses
                          , autocomplete False
                          , attribute "autocorrect" "off" -- for mobile Safari
                          , onBlurAttribute config model
                          , onKeyUpAttribute preselectedItem
                          , onKeyPressAttribute preselectedItem
                          , onInput OnQueryChange
                          , onFocus OnFocus
                          , placeholder config.prompt
                          , referenceAttr config model
                          , style inputStyles
                          ]
                        , valueAttribute
                        , idAttribute
                        ]
                    )
                    []
              ]
            , [ underline, clear ]
            ]
