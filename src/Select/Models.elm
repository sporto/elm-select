module Select.Models exposing (..)


type alias Config msg item =
    { clearClass : String
    , cutoff : Maybe Int
    , inputClass : String
    , inputStyles : List ( String, String )
    , itemClass : String
    , itemStyles : List ( String, String )
    , menuClass : String
    , menuStyles : List ( String, String )
    , onQueryChange : Maybe (String -> msg)
    , onSelect : item -> msg
    , toLabel : item -> String
    }


newConfig : (item -> msg) -> (item -> String) -> Config msg item
newConfig onSelect toLabel =
    { clearClass = ""
    , cutoff = Nothing
    , inputClass = ""
    , inputStyles = []
    , itemClass = ""
    , itemStyles = []
    , menuClass = ""
    , menuStyles = []
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
