module Select.Models exposing (State, newState)


type alias State =
    { id : String
    , query : String
    , highlightedItem : Maybe Int
    }


newState : String -> State
newState id =
    { id = id
    , query = ""
    , highlightedItem = Nothing
    }
