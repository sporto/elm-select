module Select.Models exposing (..)


type alias Style =
    ( String, String )


type alias Config msg item =
    { clearClass : String
    , clearStyles : List Style
    , clearSvgClass : String
    , underlineClass : String
    , underlineStyles : List Style
    , cutoff : Maybe Int
    , fuzzySearchAddPenalty : Maybe Int
    , fuzzySearchMovePenalty : Maybe Int
    , fuzzySearchRemovePenalty : Maybe Int
    , fuzzySearchInsertPenalty : Maybe Int
    , fuzzySearchSeparators : List String
    , inputId : Maybe String
    , inputClass : String
    , inputStyles : List Style
    , inputWrapperClass : String
    , inputWrapperStyles : List Style
    , itemClass : String
    , itemStyles : List Style
    , menuClass : String
    , menuStyles : List Style
    , notFound : String
    , notFoundClass : String
    , notFoundShown : Bool
    , notFoundStyles : List Style
    , highlightedItemClass : String
    , highlightedItemStyles : List Style
    , onQueryChange : Maybe (String -> msg)
    , onSelect : Maybe item -> msg
    , onFocus : Maybe msg
    , prompt : String
    , promptClass : String
    , promptStyles : List Style
    , scoreThreshold : Int
    , toLabel : item -> String
    , transformQuery : String -> Maybe String
    }


newConfig : (Maybe item -> msg) -> (item -> String) -> Config msg item
newConfig onSelect toLabel =
    { clearClass = ""
    , clearStyles = []
    , clearSvgClass = ""
    , underlineClass = ""
    , underlineStyles = []
    , cutoff = Nothing
    , fuzzySearchAddPenalty = Nothing
    , fuzzySearchMovePenalty = Nothing
    , fuzzySearchRemovePenalty = Nothing
    , fuzzySearchInsertPenalty = Nothing
    , fuzzySearchSeparators = []
    , inputId = Nothing
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
    , notFoundShown = True
    , notFoundStyles = []
    , highlightedItemClass = ""
    , highlightedItemStyles = []
    , onQueryChange = Nothing
    , onSelect = onSelect
    , onFocus = Nothing
    , prompt = ""
    , promptClass = ""
    , promptStyles = []
    , scoreThreshold = 500
    , toLabel = toLabel
    , transformQuery = transformQuery
    }


transformQuery : String -> Maybe String
transformQuery query =
    Just query


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
