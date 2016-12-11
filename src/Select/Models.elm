module Select.Models exposing (..)


type alias Config msg item =
    { onQueryChange : String -> msg
    , onSelect : item -> msg
    , toLabel : item -> String
    }


type alias Model item =
    { selected : List item
    }


makeModel : List item -> Model item
makeModel items =
    { selected = items
    }
