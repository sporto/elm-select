module Select.Select.Item exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Select.Models as Models
import Select.Messages as Messages


view : Models.Config msg item -> item -> Html (Messages.Msg item)
view config item =
    div [ class config.itemClass, onClick (Messages.OnSelect item) ]
        [ text (config.toLabel item)
        ]
