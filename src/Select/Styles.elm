module Select.Styles exposing
    ( clearAttrs
    , hiddenMenuStyles
    , inputAttrs
    , inputControlAttrs
    , inputId
    , inputWrapperAttrs
    , menuClass
    , menuItemAttrs
    , multiInputAttrs
    , multiInputItemAttrs
    , multiInputItemContainerAttrs
    , multiInputItemTextAttrs
    , multiInputRemoveItemAttrs
    , removeItemSvgAttrs
    , underlineAttrs
    , visibleMenuStyles
    )

import Html exposing (Attribute)
import Html.Attributes exposing (class, style)



-- INPUT CONSTANTS


inputId : String
inputId =
    "elm-select-input"


inputControlAttrs : List (Attribute msg)
inputControlAttrs =
    [ class "elm-select-input-control"
    , style "position" "relative"
    ]


inputWrapperAttrs : List (Attribute msg)
inputWrapperAttrs =
    [ class "elm-select-input-wrapper"
    , style "display" "flex"
    , style "flex" "1"
    , style "flex-direction" "row"
    , style "flex-wrap" "wrap"
    , style "overflow" "hidden"
    ]


inputAttrs : List (Attribute msg)
inputAttrs =
    [ class "elm-select-input"
    , style "flex" "1"
    , style "outline" "none"
    ]


multiInputAttrs : List (Attribute msg)
multiInputAttrs =
    [ class "elm-select-multi-input"
    ]


multiInputItemContainerAttrs : List (Attribute msg)
multiInputItemContainerAttrs =
    [ class "elm-select-multi-input-item-container"
    , style "display" "flex"
    , style "flex-direction" "row"
    , style "align-items" "center"
    , style "justify-content" "center"
    ]


multiInputItemAttrs : List (Attribute msg)
multiInputItemAttrs =
    [ class "elm-select-multi-input-item"
    , style "display" "flex"
    , style "border-width" "0.1rem"
    , style "border-radius" "0.2em"
    , style "border-color" "#E3E5E8"
    , style "background-color" "#E3E5E8"
    , style "font-size" ".75rem"
    , style "margin-right" ".2rem"
    ]


multiInputItemTextAttrs : List (Attribute msg)
multiInputItemTextAttrs =
    [ style "text-overflow" "ellipsis"
    , style "padding-left" ".5rem"
    , style "padding-right" ".3rem"
    , style "padding-top" ".05rem"
    , style "padding-bottom" ".05rem"
    ]


multiInputRemoveItemAttrs : List (Attribute msg)
multiInputRemoveItemAttrs =
    [ style "display" "flex"
    , style "alignItems" "center"
    , style "justifyContent" "center"
    , style "padding-right" ".1rem"
    ]



-- UNDERLINE


underlineAttrs : List (Attribute msg)
underlineAttrs =
    [ class "elm-select-underline"
    ]



-- ITEM CONSTANTS


menuItemAttrs : List (Attribute msg)
menuItemAttrs =
    [ class "elm-select-item"
    , style "cursor" "pointer"
    ]


clearAttrs : List (Attribute msg)
clearAttrs =
    [ class "elm-select-clear"
    , style "cursor" "pointer"
    , style "height" "1rem"
    , style "line-height" "0rem"
    , style "margin-top" "-0.5rem"
    , style "position" "absolute"
    , style "right" "0.25rem"
    , style "top" "50%"
    ]



-- MENU CONSTANTS


menuClass : String
menuClass =
    "elm-select-menu"


visibleMenuStyles : List ( String, String )
visibleMenuStyles =
    [ ( "position", "absolute" ), ( "z-index", "1" ) ]


hiddenMenuStyles : List ( String, String )
hiddenMenuStyles =
    [ ( "display", "none" ) ]


removeItemSvgAttrs : List (Attribute msg)
removeItemSvgAttrs =
    [ class "elm-select-remove-item"
    , style "cursor" "pointer"
    ]
