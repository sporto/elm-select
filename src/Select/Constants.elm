module Select.Constants exposing (..)

-- INPUT CONSTANTS


inputId : String
inputId =
    "elm-select-input"


inputWrapperClass : String
inputWrapperClass =
    "elm-select-input-wrapper "


inputWrapperStyles : List ( String, String )
inputWrapperStyles =
    [ ( "position", "relative" )
    , ( "background", "white" )
    ]


inputClass : String
inputClass =
    "elm-select-input"


inputStyles : List ( String, String )
inputStyles =
    [ ( "outline", "none" )
    , ( "border", "none" )
    , ( "display", "inline-block" )
    ]


clearClass : String
clearClass =
    "elm-select-clear "


clearStyles : List ( String, String )
clearStyles =
    [ ( "cursor", "pointer" )
    , ( "height", "1rem" )
    , ( "line-height", "0rem" )
    , ( "margin-top", "-0.5rem" )
    , ( "position", "absolute" )
    , ( "right", "0.25rem" )
    , ( "top", "50%" )
    ]


multiInputClass : String
multiInputClass =
    "elm-select-multi-input "


multiInputStyles : List ( String, String )
multiInputStyles =
    []


multiInputItemContainerClass : String
multiInputItemContainerClass =
    "elm-select-multi-input-item-container "


multiInputItemContainerStyles : List ( String, String )
multiInputItemContainerStyles =
    [ ( "display", "inline-block" )
    , ( "padding-left", "0.5rem" )
    ]


multiInputItemClass : String
multiInputItemClass =
    "elm-select-multi-input-item "


multiInputItemStyles : List ( String, String )
multiInputItemStyles =
    [ ( "border-style", "solid" )
    , ( "border-width", "0.1rem" )
    , ( "border-radius", "0.2em" )
    , ( "border-color", "#E3E5E8" )
    , ( "background-color", "#E3E5E8" )
    , ( "font-size", ".75rem" )
    , ( "padding-left", ".3rem" )
    , ( "padding-right", ".3rem" )
    , ( "padding-top", ".1rem" )
    , ( "padding-bottom", ".1rem" )
    , ( "margin-right", ".2rem" )
    ]


underlineClass : String
underlineClass =
    "elm-select-underline "


underlineStyles : List ( String, String )
underlineStyles =
    []



-- ITEM CONSTANTS


menuItemClass : String
menuItemClass =
    "elm-select-item "


menuItemStyles : List ( String, String )
menuItemStyles =
    [ ( "cursor", "pointer" )
    ]



-- MENU CONSTANTS


menuClass : String
menuClass =
    "elm-select-menu "


visibleMenuStyles : List ( String, String )
visibleMenuStyles =
    [ ( "position", "absolute" ), ( "z-index", "1" ) ]


hiddenMenuStyles : List ( String, String )
hiddenMenuStyles =
    [ ( "display", "none" ) ]



-- REMOVE ITEM CONSTANTS


removeItemSvgClass : String
removeItemSvgClass =
    "elm-select-remove-item "


removeItemSvgStyles : List ( String, String )
removeItemSvgStyles =
    [ ( "margin-left", ".4rem" )
    , ( "margin-right", ".1rem" )
    , ( "cursor", "pointer" )
    , ( "display", "inline-block" )
    , ( "line-height", "1" )
    , ( "vertical-align", "sub" )
    ]
