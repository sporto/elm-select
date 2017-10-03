module Select.Select.Input exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, placeholder, value, style, autocomplete, id)
import Html.Events exposing (on, onInput, onWithOptions, keyCode, onFocus)
import Array
import Json.Decode as Decode
import Select.Config exposing (Config)
import Select.Events exposing (onBlurAttribute)
import Select.Messages exposing (..)
import Select.Models exposing (State)
import Select.Select.Clear as Clear
import Select.Utils exposing (referenceAttr)
import Select.Search exposing (matchedItemsWithCutoff)


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


view : Config msg item -> State -> List item -> Maybe item -> Html (Msg item)
view config model items selected =
    let
        rootClasses =
            "elm-select-input-wrapper " ++ config.inputWrapperClass

        rootStyles =
            List.append [ ( "position", "relative" ) ] config.inputWrapperStyles

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
                [ [ ( "width", "100%" ) ]
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

        val =
            case model.query of
                Nothing ->
                    case selected of
                        Nothing ->
                            ""

                        Just item ->
                            config.toLabel item

                Just str ->
                    str

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
        div [ class rootClasses, style rootStyles ]
            [ input
                ([ class inputClasses
                 , autocomplete False
                 , attribute "autocorrect" "off" -- for mobile Safari
                 , onBlurAttribute config model
                 , onKeyUpAttribute preselectedItem
                 , onInput OnQueryChange
                 , onFocus OnFocus
                 , placeholder config.prompt
                 , referenceAttr config model
                 , style inputStyles
                 , value val
                 ]
                    ++ idAttribute
                )
                []
            , underline
            , clear
            ]
