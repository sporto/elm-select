module Shared exposing (filter)

import Simple.Fuzzy


filter : (a -> String) -> String -> List a -> Maybe (List a)
filter toLabel query items =
    if String.length query < 4 then
        Nothing

    else
        items
            |> Simple.Fuzzy.filter toLabel query
            |> Just
