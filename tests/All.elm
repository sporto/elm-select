module All exposing (..)

import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Select.SearchTest


suite : Test
suite =
    describe "all"
        [ Select.SearchTest.all
        ]
