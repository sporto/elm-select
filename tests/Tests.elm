module Tests exposing
    ( IceCream(..)
    , availableItems
    , config
    , inputTests
    , model
    , suite
    , toLabel
    )

import Expect
import Html.Attributes exposing (attribute, placeholder, value)
import Select
import Select.Search as Search
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
        , filter = \query items -> Just items
        , toMsg = always ()
        }
        |> Select.withPrompt "Select a flavour"


model =
    Select.init "id"


inputTests =
    describe "input"
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


testEqual testCase a b =
    test testCase <|
        \_ ->
            Expect.equal
                a
                b


menuTests =
    describe "menu"
        [ test "It shows the custom item" <|
            \_ ->
                Select.view
                    (config
                        |> Select.withCustomInput Custom
                    )
                    (model |> Select.withQuery (Just "Passion"))
                    availableItems
                    []
                    |> Query.fromHtml
                    |> Query.findAll
                        [ Selector.class "elm-select-menu-item"
                        , Selector.attribute (attribute "data-select-item" "Passion")
                        ]
                    |> Query.count (Expect.equal 1)
        , test "It can show multiple custom items" <|
            \_ ->
                Select.view
                    (config
                        |> Select.withCustomInput Custom
                    )
                    (model |> Select.withQuery (Just "Passion, Mango"))
                    availableItems
                    []
                    |> Query.fromHtml
                    |> Expect.all
                        [ Query.findAll
                            [ Selector.class "elm-select-menu-item"
                            , Selector.attribute (attribute "data-select-item" "Passion")
                            ]
                            >> Query.count (Expect.equal 1)
                        , Query.findAll
                            [ Selector.class "elm-select-menu-item"
                            , Selector.attribute (attribute "data-select-item" "Mango")
                            ]
                            >> Query.count (Expect.equal 1)
                        ]
        ]


filterItemsTests =
    let
        args =
            { filter = \query items -> List.filter ((==) query) items |> Just
            , query = ""
            , toLabel = identity
            , valueSeparators = []
            }
    in
    describe "filterItems"
        [ testEqual
            "It returns the filtered items"
            (Search.filterItems
                { args | query = "One" }
                [ "One", "Two", "Three" ]
            )
            (Just [ "One" ])
        , testEqual
            "It can return two when the query uses the separators"
            (Search.filterItems
                { args
                    | query = "One, Two"
                    , valueSeparators = [ "," ]
                }
                [ "One", "Two", "Three" ]
            )
            (Just [ "One", "Two" ])
        , testEqual
            "It doesn't match when there are no separators"
            (Search.filterItems
                { args
                    | query = "One, Two"
                    , valueSeparators = []
                }
                [ "One", "Two", "Three" ]
            )
            (Just [])
        ]


suite : Test
suite =
    describe "all"
        [ inputTests
        , menuTests
        , filterItemsTests
        ]
