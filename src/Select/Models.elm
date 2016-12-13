module Select.Models exposing (..)


type alias Config msg item =
    { cutoff : Maybe Int
    , inputClass : String
    , itemClass : String
    , menuClass : String
    , onQueryChange : Maybe (String -> msg)
    , onSelect : item -> msg
    , toLabel : item -> String
    }


newConfig : (item -> msg) -> (item -> String) -> Config msg item
newConfig onSelect toLabel =
    { cutoff = Nothing
    , inputClass = ""
    , itemClass = ""
    , menuClass = ""
    , onQueryChange = Nothing
    , onSelect = onSelect
    , toLabel = toLabel
    }


type alias State =
    { id : String
    , query : Maybe String
    }


newState : String -> State
newState id =
    { id = id
    , query = Nothing
    }
