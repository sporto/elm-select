module Select.SearchTest exposing (..)

import Expect exposing (Expectation)
import Select.Search exposing (..)
import Test exposing (..)


testScoreForItem =
    let
        inputs =
            [ ( "Foo"
              , 1
              , 1
              )
            ]

        run ( testCase, input, expected ) =
            test testCase <|
                \() -> Expect.equal input expected
    in
        describe "scoreForItem" (List.map run inputs)


all =
    describe "SearchTest"
        [ testScoreForItem
        ]
