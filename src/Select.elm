module Select exposing (..)

import Html exposing (..)
import Html.Attributes exposing (value)
import Html.Events exposing (onInput)
import Select.Models as Models
import Select.Option


type alias Config msg item =
    Models.Config msg item


type Model
    = Model Models.Model


type Msg
    = NoOp


model : Model
model =
    Model
        { value = ""
        }


view : Models.Config msg item -> List item -> Maybe item -> Html msg
view config options selectedItem =
    let
        val =
            case selectedItem of
                Nothing ->
                    ""

                Just item ->
                    config.toLabel item
    in
        div []
            [ div [ onInput config.onQueryChange ] [ input [ value val ] [] ]
            , div [] (List.map (Select.Option.view config) options)
            ]


update : Msg -> Model -> Model
update msg model =
    model
