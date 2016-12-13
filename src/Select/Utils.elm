module Select.Utils exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, value)
import Select.Models exposing (..)


referenceDataName : String
referenceDataName =
    "data-select-id"


referenceAttr : Config msg item -> State -> Attribute msg2
referenceAttr config model =
    attribute referenceDataName model.id
