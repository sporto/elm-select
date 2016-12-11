module Select.Models exposing (..)


type alias Config msg item =
    { onQueryChange : String -> msg
    , onSelect : item -> msg
    , toLabel : item -> String
    }


type alias Model item =
    { selected : Maybe item
    , query : String
    }


new : Maybe item -> Model item
new maybeItem =
    { selected = maybeItem
    , query = ""
    }
