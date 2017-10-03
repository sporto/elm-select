module Select.Config exposing (..)

import Fuzzy


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
    , cutoff = Nothing
    , fuzzySearchAddPenalty = Nothing
    , fuzzySearchInsertPenalty = Nothing
    , fuzzySearchMovePenalty = Nothing
    , fuzzySearchRemovePenalty = Nothing
    , fuzzySearchSeparators = []
    , underlineStyles = []
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
    , scoreThreshold = 2000
    , toLabel = toLabel
    , transformQuery = transformQuery
    }


transformQuery : String -> Maybe String
transformQuery query =
    Just query


fuzzyOptions : Config msg item -> List Fuzzy.Config
fuzzyOptions config =
    []
        |> fuzzyAddPenalty config
        |> fuzzyRemovePenalty config
        |> fuzzyMovePenalty config
        |> fuzzyInsertPenalty config


fuzzyAddPenalty : Config msg item -> List Fuzzy.Config -> List Fuzzy.Config
fuzzyAddPenalty config options =
    case config.fuzzySearchAddPenalty of
        Just penalty ->
            options ++ [ Fuzzy.addPenalty penalty ]

        _ ->
            options


fuzzyRemovePenalty : Config msg item -> List Fuzzy.Config -> List Fuzzy.Config
fuzzyRemovePenalty config options =
    case config.fuzzySearchRemovePenalty of
        Just penalty ->
            options ++ [ Fuzzy.removePenalty penalty ]

        _ ->
            options


fuzzyMovePenalty : Config msg item -> List Fuzzy.Config -> List Fuzzy.Config
fuzzyMovePenalty config options =
    case config.fuzzySearchMovePenalty of
        Just penalty ->
            options ++ [ Fuzzy.movePenalty penalty ]

        _ ->
            options


fuzzyInsertPenalty : Config msg item -> List Fuzzy.Config -> List Fuzzy.Config
fuzzyInsertPenalty config options =
    case config.fuzzySearchInsertPenalty of
        Just penalty ->
            options ++ [ Fuzzy.insertPenalty penalty ]

        _ ->
            options
