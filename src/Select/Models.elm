module Select.Models exposing (..)


type alias Config msg item =
    { onQueryChange : String -> msg
    , onSelect : item -> msg
    , toLabel : item -> String
    }


type alias Model =
    { query : Maybe String
    }


new : Maybe item -> Model
new maybeItem =
    { query = Nothing
    }
