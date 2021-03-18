module Example3Multi exposing
    ( Color(..)
    , Model
    , Msg(..)
    , colors
    , initialModel
    , update
    , view
    )

import Html exposing (..)
import Html.Attributes exposing (class, style)
import Select
import Shared


{-| Model to be passed to the select component. You model can be anything.
E.g. Records, tuples or just strings.
-}
type Color
    = Red
    | Yellow
    | Blue
    | Orange
    | Green
    | Purple
    | White
    | Black
    | Grey


{-| In your main application model you should store:
-}
type alias Model =
    { id : String
    , colors : List Color
    , selectedColors : List Color
    , selectState : Select.State
    }


{-| List of colors
-}
colors : List Color
colors =
    [ Red
    , Yellow
    , Blue
    , Orange
    , Green
    , Purple
    , White
    , Black
    , Grey
    ]


colorToString : Color -> String
colorToString c =
    case c of
        Red ->
            "Red"

        Yellow ->
            "Yellow"

        Blue ->
            "Blue"

        Orange ->
            "Orange"

        Green ->
            "Green"

        Purple ->
            "Purple"

        White ->
            "White"

        Black ->
            "Black"

        Grey ->
            "Grey"


{-| Your model should store the selected item and the state of the Select component(s)
-}
initialModel : String -> Model
initialModel id =
    { id = id
    , colors = colors
    , selectedColors = [ Green, Black ]
    , selectState = Select.newState id
    }


{-| Your application messages need to include:

  - OnSelect item : This will be called when an item is selected
  - SelectMsg (Select.Msg item) : A message that wraps internal Select library messages. This is necessary to route messages back to the component.

-}
type Msg
    = NoOp
    | OnSelect (Maybe Color)
    | OnRemoveItem Color
    | SelectMsg (Select.Msg Color)


{-| Create the configuration for the Select component

`Select.newConfig` takes two args:

  - The selection message e.g. `OnSelect`
  - A function that extract a label from an item e.g. `.label`

All the functions after |> are optional configuration.

-}
selectConfig : Select.Config Msg Color
selectConfig =
    Select.newConfig
        { onSelect = OnSelect
        , toLabel = colorToString
        , filter = Shared.filter 2 colorToString
        , toMsg = SelectMsg
        }
        |> Select.withMultiSelection True
        |> Select.withOnRemoveItem OnRemoveItem
        |> Select.withCutoff 12
        |> Select.withInputWrapperAttrs
            [ style "padding" "0.4rem" ]
        |> Select.withNotFound "No matches"
        |> Select.withPrompt "Select a color"



{-| Your update function should route messages back to the Select component, see `SelectMsg`.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- OnSelect is triggered when a selection is made on the Select component.
        OnSelect maybeColor ->
            let
                selectedColors =
                    maybeColor
                        |> Maybe.map (List.singleton >> List.append model.selectedColors)
                        |> Maybe.withDefault []
            in
            ( { model | selectedColors = selectedColors }, Cmd.none )

        OnRemoveItem colorToRemove ->
            let
                selectedColors =
                    List.filter (\curColor -> curColor /= colorToRemove)
                        model.selectedColors
            in
            ( { model | selectedColors = selectedColors }, Cmd.none )

        -- Route message to the Select component.
        -- The returned command is important.
        SelectMsg subMsg ->
            let
                ( updated, cmd ) =
                    Select.update selectConfig subMsg model.selectState
            in
            ( { model | selectState = updated }, cmd )

        NoOp ->
            ( model, Cmd.none )


{-| Your view renders the select component passing the config, state, list of items and the currently selected item.
-}
view : Model -> Html Msg
view model =
    let
        currentSelection =
            p
                []
                [ text (String.join ", " <| List.map colorToString model.selectedColors) ]

        select =
            Select.view selectConfig
                model.selectState
                model.colors
                model.selectedColors
    in
    div [ class "demo-box" ]
        [ h3 [] [ text "MultiSelect example" ]
        , currentSelection
        , p
            []
            [ label [] [ text "Pick colors" ]
            ]
        , p
            []
            [ select
            ]
        ]
