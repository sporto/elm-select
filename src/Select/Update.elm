module Select.Update exposing (..)

import Select.Models as Models
import Select.Messages as Messages


update : Models.Config msg item -> Messages.Msg item -> Models.Model -> Models.Model
update config msg model =
    case msg of
        Messages.OnQueryChange value ->
            { model | query = value }

        Messages.OnSelect item ->
            let
                query =
                    config.toLabel item
            in
                { model | query = query }

        Messages.NoOp ->
            model
