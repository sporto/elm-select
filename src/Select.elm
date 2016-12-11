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


type alias Select item =
    { view : Model item -> List item -> Html (Msg item)
    , update : Msg item -> Model item -> Model item
    }


new : Config msg item -> Select item
new config =
    { view = view config
    , update = update config
    }


model : Maybe item -> Model item
model maybeItem =
    PrivateModel (Models.new maybeItem)


view : Models.Config msg item -> Model item -> List item -> Html (Msg item)
view config model items =
    let
        privateModel =
            case model of
                PrivateModel m ->
                    m
    in
        Html.map PrivateMsg (Select.Select.view config privateModel items)


update : Models.Config msg item -> Msg item -> Model item -> Model item
update config msg model =
    case msg of
        PrivateMsg privMsg ->
            case model of
                PrivateModel privModel ->
                    PrivateModel (Select.Update.update config privMsg privModel)
