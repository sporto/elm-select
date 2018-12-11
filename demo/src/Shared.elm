module Shared exposing (filter)


filter : String -> List a -> Maybe (List a)
filter query items =
    Just items
