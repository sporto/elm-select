module Select.Models exposing (..)


type alias Style =
    ( String, String )


type alias Config msg item =
    { clearClass : String
    , clearStyles : List Style
    , clearSvgClass : String
    , cutoff : Maybe Int
    , inputClass : String
    , inputStyles : List Style
    , inputWrapperClass : String
    , inputWrapperStyles : List Style
    , itemClass : String
    , itemClass : String
    , itemStyles : List Style
    , menuClass : String
    , menuClass : String
    , menuStyles : List Style
    , notFound : String
    , notFoundClass : String
    , notFoundStyles : List Style
    , onQueryChange : Maybe (String -> msg)
    , onSelect : Maybe item -> msg
    , prompt : String
    , promptClass : String
    , promptStyles : List Style
    , fuzzySearchAddPenalty : Maybe Int
    , fuzzySearchRemovePenalty : Maybe Int
    , fuzzySearchMovePenalty : Maybe Int
    , fuzzySearchSeparators : List String
    , toLabel : item -> String
    }


newConfig : (Maybe item -> msg) -> (item -> String) -> Config msg item
newConfig onSelect toLabel =
    { clearClass = ""
    , clearStyles = []
    , clearSvgClass = ""
    , cutoff = Nothing
    , inputClass = ""
    , inputStyles = []
    , inputWrapperClass = ""
    , inputWrapperStyles = []
    , itemClass = ""
    , itemStyles = []
    , menuClass = ""
    , menuStyles = []
    , notFound = "No results found"
    , notFoundClass = ""
    , notFoundStyles = []
    , onQueryChange = Nothing
    , onSelect = onSelect
    , prompt = ""
    , promptClass = ""
    , promptStyles = []
    , fuzzySearchAddPenalty = Nothing
    , fuzzySearchRemovePenalty = Nothing
    , fuzzySearchMovePenalty = Nothing
    , fuzzySearchSeparators = []
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
