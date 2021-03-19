module Example exposing
    ( Model
    , Msg(..)
    , update
    , view
    , initialModel
    )

import Html exposing (..)
import Html.Attributes exposing (class, style)
import Select
import Shared


type alias Model item =
    { id : String
    , available : List item
    , itemToLabel : item -> String
    , selected : List item
    , selectState : Select.State
    , selectConfig : Select.Config (Msg item) item
    }


type alias InitArgs item =
    { id: String
    , available : List item
    , selected : List item
    , selectConfig : Select.Config (Msg item) item
    , itemToLabel : item -> String
    }


initialModel : InitArgs item -> Model item
initialModel args =
    { id = args.id
    , available = args.available
    , itemToLabel = args.itemToLabel
    , selected = args.selected
    , selectState = Select.newState args.id
    , selectConfig = args.selectConfig
    }


type Msg item
    = NoOp
    | OnSelect (Maybe item)
    | OnRemoveItem item
    | SelectMsg (Select.Msg item)


update : Msg item -> Model item -> ( Model item, Cmd (Msg item) )
update msg model =
    case msg of
        OnSelect maybeColor ->
            let
                selected =
                    maybeColor
                        |> Maybe.map (List.singleton >> List.append model.selected)
                        |> Maybe.withDefault []
            in
            ( { model | selected = selected }, Cmd.none )

        OnRemoveItem colorToRemove ->
            let
                selected =
                    List.filter (\curColor -> curColor /= colorToRemove)
                        model.selected
            in
            ( { model | selected = selected }, Cmd.none )

        SelectMsg subMsg ->
            let
                ( updated, cmd ) =
                    Select.update
                        model.selectConfig
                        subMsg
                        model.selectState
            in
            ( { model | selectState = updated }, cmd )

        NoOp ->
            ( model, Cmd.none )


view : Model item -> String -> Html (Msg item)
view model title =
    let
        currentSelection =
            p
                []
                [ text (String.join ", " <| List.map model.itemToLabel model.selected) ]

        select =
            Select.view
                model.selectConfig
                model.selectState
                model.available
                model.selected
    in
    div [ class "demo-box" ]
        [ h3 [] [ text title ]
        , currentSelection
        , p
            []
            [ select
            ]
        ]
