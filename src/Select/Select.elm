module Select.Select exposing (..)

import Html exposing (..)
import Select.Messages as Messages
import Select.Models as Models
import Select.Select.Items
import Select.Select.Input


view : Models.Config msg item -> Models.Model -> List item -> Maybe item -> Html (Messages.Msg item)
view config model items selected =
    div []
        [ div [] [ Select.Select.Input.view config model selected ]
        , div [] [ Select.Select.Items.view config model items selected ]
        ]
