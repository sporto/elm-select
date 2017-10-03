module Select.Utils exposing (..)

import Html exposing (Attribute)
import Html.Attributes exposing (attribute)
import Select.Config exposing (Config)
import Select.Models exposing (State)


referenceDataName : String
referenceDataName =
    "data-select-id"


referenceAttr : Config msg item -> State -> Attribute msg2
referenceAttr config model =
    attribute referenceDataName model.id
