module Select exposing (..)

import Html exposing (..)
import Select.Select
import Select.Models as Models
import Select.Messages as Messages
import Select.Update


type alias Config msg item =
    Models.Config msg item


type Model
    = PrivateModel (Models.Model)


type Msg item
    = PrivateMsg (Messages.Msg item)


type alias Select item =
    { model : Model
    , view : Model -> List item -> Html (Msg item)
    , update : Msg item -> Model item -> Model
    }



-- new : Config msg item -> Maybe item -> Select item


new config maybeItem =
    { model = PrivateModel (Models.new maybeItem)
    , view = view config
    , update = update config
    }


view : Models.Config msg item -> Model -> List item -> Maybe item -> Html (Msg item)
view config model items selected =
    let
        privateModel =
            case model of
                PrivateModel m ->
                    m
    in
        Html.map PrivateMsg (Select.Select.view config privateModel items selected)


update : Models.Config msg item -> Msg item -> Model -> ( Model, Cmd msg )
update config msg model =
    case msg of
        PrivateMsg privMsg ->
            case model of
                PrivateModel privModel ->
                    let
                        ( mdl, cmd ) =
                            Select.Update.update config privMsg privModel
                    in
                        ( PrivateModel mdl, cmd )
