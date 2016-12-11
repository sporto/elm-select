module Select exposing (..)

import Html exposing (..)
import Select.Select
import Select.Models as Models
import Select.Messages as Messages
import Select.Update


type alias Config msg item =
    Models.Config msg item


type Model item
    = PrivateModel (Models.Model item)


type Msg item
    = PrivateMsg (Messages.Msg item)


model : List item -> Model item
model items =
    PrivateModel (Models.makeModel items)


view : Models.Config msg item -> Model item -> List item -> Html (Msg item)
view config model items =
    let
        privateModel =
            case model of
                PrivateModel m ->
                    m
    in
        Html.map PrivateMsg (Select.Select.view config privateModel items)


update : Msg item -> Model item -> Model item
update msg model =
    case msg of
        PrivateMsg privMsg ->
            case model of
                PrivateModel privModel ->
                    PrivateModel (Select.Update.update privMsg privModel)
