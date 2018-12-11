module Select.Config exposing
    ( Config
    , Style
    , fuzzyAddPenalty
    , fuzzyInsertPenalty
    , fuzzyMovePenalty
    , fuzzyOptions
    , fuzzyRemovePenalty
    , newConfig
    , transformQuery
    )

import Fuzzy
import Html exposing (Html)
import Select.Styles as Styles


type alias Style =
    ( String, String )


type alias RequiredConfig msg item =
    { onSelect : Maybe item -> msg
    , toLabel : item -> String
    , filter : String -> List item -> List item
    }


type alias Config msg item =
    { clearClass : String
    , clearStyles : List Style
    , clearSvgClass : String
    , cutoff : Maybe Int
    , emptySearch : Bool
    , fuzzyMatching : Bool
    , fuzzySearchAddPenalty : Maybe Int
    , fuzzySearchMovePenalty : Maybe Int
    , fuzzySearchRemovePenalty : Maybe Int
    , fuzzySearchInsertPenalty : Maybe Int
    , fuzzySearchSeparators : List String
    , highlightedItemClass : String
    , highlightedItemStyles : List Style
    , inputId : String
    , inputClass : String
    , inputStyles : List Style
    , inputControlClass : String
    , inputControlStyles : List Style
    , inputWrapperClass : String
    , inputWrapperStyles : List Style
    , itemClass : String
    , itemStyles : List Style
    , itemHtml : Maybe (item -> Html Never)
    , menuClass : String
    , menuStyles : List Style
    , multiInputItemContainerClass : String
    , multiInputItemContainerStyles : List Style
    , multiInputItemClass : String
    , multiInputItemStyles : List Style
    , notFound : String
    , notFoundClass : String
    , notFoundShown : Bool
    , notFoundStyles : List Style
    , onQueryChange : Maybe (String -> msg)
    , onSelect : Maybe item -> msg
    , onFocus : Maybe msg
    , onRemoveItem : Maybe (item -> msg)
    , prompt : String
    , promptClass : String
    , promptStyles : List Style
    , removeItemSvgClass : String
    , removeItemSvgStyles : List Style
    , scoreThreshold : Int
    , toLabel : item -> String
    , transformQuery : String -> Maybe String
    , underlineClass : String
    , underlineStyles : List Style
    }


newConfig : RequiredConfig msg item -> Config msg item
newConfig requiredConfig =
    { clearClass = ""
    , clearStyles = []
    , clearSvgClass = ""
    , emptySearch = False
    , cutoff = Nothing
    , fuzzyMatching = True
    , fuzzySearchAddPenalty = Nothing
    , fuzzySearchInsertPenalty = Nothing
    , fuzzySearchMovePenalty = Nothing
    , fuzzySearchRemovePenalty = Nothing
    , fuzzySearchSeparators = [ " " ]
    , highlightedItemClass = ""
    , highlightedItemStyles = []
    , underlineStyles = []
    , inputId = Styles.inputId
    , inputClass = ""
    , inputControlClass = ""
    , inputControlStyles = []
    , inputStyles = []
    , inputWrapperClass = ""
    , inputWrapperStyles = []
    , itemClass = ""
    , itemStyles = []
    , itemHtml = Nothing
    , menuClass = ""
    , menuStyles = []
    , multiInputItemContainerClass = ""
    , multiInputItemContainerStyles = []
    , multiInputItemClass = ""
    , multiInputItemStyles = []
    , notFound = "No results found"
    , notFoundClass = ""
    , notFoundShown = True
    , notFoundStyles = []
    , onQueryChange = Nothing
    , onSelect = requiredConfig.onSelect
    , onFocus = Nothing
    , onRemoveItem = Nothing
    , prompt = ""
    , promptClass = ""
    , promptStyles = []
    , removeItemSvgClass = ""
    , removeItemSvgStyles = []
    , scoreThreshold = 2000
    , toLabel = requiredConfig.toLabel
    , transformQuery = transformQuery
    , underlineClass = ""
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
