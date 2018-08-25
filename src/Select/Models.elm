module Select.Models exposing (Selected(..), State, newState)


type Selected item
    = Single item
    | Many (List item)


type alias State =
    { id : String
    , query : Maybe String
    , highlightedItem : Maybe Int
    }


newState : String -> State
newState id =
    { id = id
    , query = Nothing
    , highlightedItem = Nothing
    }
