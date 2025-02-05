module Select.Config exposing
    ( Config
    , Style
    , newConfig
    )

import Html exposing (Attribute, Html)
import Select.Messages exposing (Msg)


type alias Style =
    ( String, String )


type alias RequiredConfig msg item =
    { filter : String -> List item -> Maybe (List item)
    , toLabel : item -> String
    , onSelect : Maybe item -> msg
    , toMsg : Msg item -> msg
    }


type alias Config msg item =
    { clearAttrs : List (Attribute msg)
    , clearSvgClass : String
    , clearHtml : Maybe (Html msg)
    , customInput : Maybe (String -> item)
    , cutoff : Maybe Int
    , emptySearch : Bool
    , filter : String -> List item -> Maybe (List item)
    , hasClear : Bool
    , highlightedItemAttrs : List (Attribute msg)
    , inputAttrs : List (Attribute msg)
    , inputWrapperAttrs : List (Attribute msg)
    , isMultiSelect : Bool
    , itemAttrs : List (Attribute msg)
    , itemHtml : Maybe (item -> Html msg)
    , menuAttrs : List (Attribute msg)
    , multiInputItemAttrs : List (Attribute msg)
    , multiInputItemContainerAttrs : List (Attribute msg)
    , multiInputItemRemovable: Maybe (item -> Bool)
    , notFound : String
    , notFoundAttrs : List (Attribute msg)
    , notFoundShown : Bool
    , onFocus : Maybe msg
    , onBlur : Maybe msg
    , onEsc : Maybe msg
    , onQueryChange : Maybe (String -> msg)
    , onRemoveItem : Maybe (item -> msg)
    , onSelect : Maybe item -> msg
    , prompt : String
    , promptAttrs : List (Attribute msg)
    , removeItemSvgAttrs : List (Attribute msg)
    , scoreThreshold : Int
    , selectedItemAttrs : List (Attribute msg)
    , toLabel : item -> String
    , toMsg : Msg item -> msg
    , transformInput : String -> String
    , transformQuery : String -> String
    , valueSeparators : List String
    }


newConfig : RequiredConfig msg item -> Config msg item
newConfig requiredConfig =
    { clearAttrs = []
    , clearSvgClass = ""
    , clearHtml = Nothing
    , customInput = Nothing
    , emptySearch = False
    , filter = requiredConfig.filter
    , cutoff = Nothing
    , hasClear = True
    , highlightedItemAttrs = []
    , inputAttrs = []
    , inputWrapperAttrs = []
    , isMultiSelect = False
    , itemAttrs = []
    , itemHtml = Nothing
    , menuAttrs = []
    , multiInputItemAttrs = []
    , multiInputItemContainerAttrs = []
    , multiInputItemRemovable = Nothing
    , notFound = "No results found"
    , notFoundAttrs = []
    , notFoundShown = True
    , onFocus = Nothing
    , onBlur = Nothing
    , onEsc = Nothing
    , onQueryChange = Nothing
    , onRemoveItem = Nothing
    , onSelect = requiredConfig.onSelect
    , prompt = ""
    , promptAttrs = []
    , removeItemSvgAttrs = []
    , scoreThreshold = 2000
    , selectedItemAttrs = []
    , toLabel = requiredConfig.toLabel
    , toMsg = requiredConfig.toMsg
    , transformInput = identity
    , transformQuery = identity
    , valueSeparators = [ "\n", "\t", "," ]
    }
