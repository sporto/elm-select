module Select.Utils exposing (andThenSelected, difference, referenceAttr, referenceDataName)

import Html exposing (Attribute)
import Html.Attributes exposing (attribute)
import Select.Config exposing (Config)
import Select.Models as Models exposing (Selected, State)


referenceDataName : String
referenceDataName =
    "data-select-id"


referenceAttr : Config msg item -> State -> Attribute msg2
referenceAttr config model =
    attribute referenceDataName model.id


difference : List item -> List item -> List item
difference listA listB =
    List.filter (\x -> not <| List.any (\y -> x == y) listB) listA


andThenSelected :
    Maybe (Selected item)
    -> (item -> Maybe result)
    -> (List item -> Maybe result)
    -> Maybe result
andThenSelected selected fromSingle fromMulti =
    Maybe.andThen
        (\value ->
            case value of
                Models.Single item ->
                    fromSingle item

                Models.Many items ->
                    fromMulti items
        )
        selected
