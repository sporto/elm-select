module Select.Utils exposing
    ( difference
    , referenceAttr
    , referenceDataName
    , stylesToAttrs
    )

import Html exposing (Attribute)
import Html.Attributes exposing (attribute, style)
import Select.Config exposing (Config)
import Select.Models as Models exposing (State)


referenceDataName : String
referenceDataName =
    "data-select-id"


referenceAttr : Config msg item -> State -> Attribute msg2
referenceAttr config model =
    attribute referenceDataName model.id


difference : List item -> List item -> List item
difference listA listB =
    List.filter (\x -> not <| List.any (\y -> x == y) listB) listA


stylesToAttrs : List ( String, String ) -> List (Html.Attribute msg)
stylesToAttrs styles =
    List.map (\( k, v ) -> style k v) styles
