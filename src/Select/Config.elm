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
    , clearSvgAttrs : List (Attribute msg)
    , clearHtml : Maybe (Html msg)
    , customInput : Maybe (String -> item)
    , cutoff : Maybe Int
    , emptySearch : Bool
    , filter : String -> List item -> Maybe (List item)
    , hasClear : Bool
    , highlightedItemAttrs : List (Attribute msg)
    , inputAttrs : List (Attribute msg)
    , inputControlAttrs : List (Attribute msg)
    , inputWrapperAttrs : List (Attribute msg)
    , itemAttrs : List (Attribute msg)
    , itemHtml : Maybe (item -> Html msg)
    , isMultiSelect : Bool
    , menuAttrs : List (Attribute msg)
    , multiInputItemContainerAttrs : List (Attribute msg)
    , multiInputItemAttrs : List (Attribute msg)
    , notFound : String
    , notFoundAttrs : List (Attribute msg)
    , notFoundShown : Bool
    , onQueryChange : Maybe (String -> msg)
    , onSelect : Maybe item -> msg
    , onFocus : Maybe msg
    , onRemoveItem : Maybe (item -> msg)
    , prompt : String
    , promptAttrs : List (Attribute msg)
    , removeItemSvgAttrs : List (Attribute msg)
    , scoreThreshold : Int
    , toLabel : item -> String
    , transformQuery : String -> String
    , toMsg : Msg item -> msg
    }


newConfig : RequiredConfig msg item -> Config msg item
newConfig requiredConfig =
    { clearAttrs = []
    , clearSvgAttrs = []
    , clearHtml = Nothing
    , customInput = Nothing
    , emptySearch = False
    , filter = requiredConfig.filter
    , cutoff = Nothing
    , hasClear = True
    , highlightedItemAttrs = []
    , inputAttrs = []
    , inputControlAttrs = []
    , inputWrapperAttrs = []
    , itemAttrs = []
    , itemHtml = Nothing
    , isMultiSelect = False
    , menuAttrs = []
    , multiInputItemContainerAttrs = []
    , multiInputItemAttrs = []
    , notFound = "No results found"
    , notFoundAttrs = []
    , notFoundShown = True
    , onQueryChange = Nothing
    , onSelect = requiredConfig.onSelect
    , onFocus = Nothing
    , onRemoveItem = Nothing
    , prompt = ""
    , promptAttrs = []
    , removeItemSvgAttrs = []
    , scoreThreshold = 2000
    , toLabel = requiredConfig.toLabel
    , transformQuery = identity
    , toMsg = requiredConfig.toMsg
    }
