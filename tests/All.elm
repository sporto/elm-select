module All exposing (suite)

import Expect
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


noTest =
    test "Placeholder" <|
        \_ ->
            Expect.equal 1 1


suite : Test
suite =
    describe "all"
        [ noTest ]
