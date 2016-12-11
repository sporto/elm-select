module Select.Update exposing (..)

import Select.Models as Models
import Select.Messages as Messages
import Task


update : Models.Config msg item -> Messages.Msg item -> Models.Model -> ( Models.Model, Cmd msg )
update config msg model =
    case msg of
        Messages.OnQueryChange value ->
            ( { model | query = Just value }, Cmd.none )

        Messages.OnSelect item ->
            let
                cmd =
                    Task.succeed item
                        |> Task.perform config.onSelect
            in
                ( { model | query = Nothing }, cmd )

        Messages.NoOp ->
            ( model, Cmd.none )
