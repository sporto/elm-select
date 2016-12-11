module Select.Select.Input exposing (..)

import Html exposing (..)
import Html.Attributes exposing (value)
import Html.Events exposing (onInput)
import Select.Messages as Messages
import Select.Models as Models


view : Models.Config msg item -> Models.Model -> Maybe item -> Html (Messages.Msg item)
view config model selected =
    let
        val =
            case model.query of
                Nothing ->
                    case selected of
                        Nothing ->
                            ""

                        Just item ->
                            config.toLabel item

                Just str ->
                    str
    in
        input [ onInput Messages.OnQueryChange, value val ] []
