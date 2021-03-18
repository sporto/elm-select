module Select.Shared exposing
    ( classNames
    , difference
    , referenceAttr
    , referenceDataName
    )

import Html exposing (Attribute)
import Html.Attributes exposing (attribute, style)
import Select.Config exposing (Config)
import Select.Models as Models exposing (State)


classNames =
    { inputControl = "elm-select-input-control"
    , inputWrapper = "elm-select-input-wrapper"
    , input = "elm-select-input"
    , clear = "elm-select-clear"

    -- Multi input
    -- , multiInput = "elm-select-multi-input"
    , multiInputItemContainer = "elm-select-multi-input-item-container"
    , multiInputItem = "elm-select-multi-input-item"
    , multiInputItemText = "elm-select-multi-input-item-text"
    , multiInputItemRemove = "elm-select-multi-input-item-remove"

    -- Menu
    , menu = "elm-select-menu"
    , menuItem = "elm-select-menu-item"
    , menuItemRemove = "elm-select-menu-item-remove"
    }


referenceDataName : String
referenceDataName =
    "data-select-id"


referenceAttr : Config msg item -> State -> Attribute msg2
referenceAttr config model =
    attribute referenceDataName model.id


difference : List item -> List item -> List item
difference listA listB =
    List.filter (\x -> not <| List.any (\y -> x == y) listB) listA
