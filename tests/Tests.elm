module Tests exposing
    ( IceCream(..)
    , availableItems
    , config
    , menuTests
    , model
    , suite
    , toLabel
    )

import Html.Attributes exposing (placeholder, value)
import Select
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector as Selector


type IceCream
    = Chocolate
    | Baccio
    | Strawberry
    | Watermelon
    | Apple
    | Banana
    | Custom String


toLabel : IceCream -> String
toLabel iceCream =
    case iceCream of
        Chocolate ->
            "Chocolate"

        Baccio ->
            "Baccio"

        Strawberry ->
            "Strawberry"

        Watermelon ->
            "Watermelon"

        Apple ->
            "Apple"

        Banana ->
            "Banana"

        Custom custom ->
            custom


availableItems =
    [ Apple
    , Chocolate
    , Baccio
    , Banana
    , Strawberry
    , Watermelon
    ]


config =
    Select.newConfig
        { onSelect = always ()
        , toLabel = toLabel
        , filter = \_ _ -> Nothing
        , toMsg = always ()
        }
        |> Select.withPrompt "Select a flavour"


model =
    Select.newState "id"


menuTests =
    describe "menu"
        [ test "It renders" <|
            \_ ->
                Select.view
                    config
                    model
                    availableItems
                    []
                    |> Query.fromHtml
                    |> Query.has [ Selector.class "elm-select" ]
        , test "It shows the given placeholder" <|
            \_ ->
                Select.view
                    config
                    model
                    availableItems
                    [ Watermelon ]
                    |> Query.fromHtml
                    |> Query.has [ Selector.attribute (placeholder "Select a flavour") ]
        , test "It shows the selected item" <|
            \_ ->
                Select.view
                    config
                    model
                    availableItems
                    [ Watermelon ]
                    |> Query.fromHtml
                    |> Query.has [ Selector.attribute (value "Watermelon") ]
        ]


suite : Test
suite =
    describe "all"
        [ menuTests
        ]
