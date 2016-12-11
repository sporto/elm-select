module Select.Update exposing (..)

import Select.Models as Models
import Select.Messages as Messages


update : Messages.Msg item -> Models.Model item -> Models.Model item
update msg model =
    case msg of
        Messages.OnQueryChange value ->
            model

        Messages.OnSelect item ->
            { model | selected = [ item ] }

        Messages.NoOp ->
            model
