module Select.Select.Item exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Select.Models as Models
import Select.Messages as Messages


view : Models.Config msg item -> item -> Html (Messages.Msg item)
view config item =
    div [ onClick (Messages.OnSelect item) ]
        [ text (config.toLabel item)
        ]
