module Example3 exposing (Color(..), Model, Msg(..), colors, initialModel, selectConfig, update, view)

import Html exposing (..)
import Html.Attributes exposing (class)
import Select


{-| Model to be passed to the select component. You model can be anything.
E.g. Records, tuples or just strings.
-}
type Color
    = Red
    | Orange
    | Yellow
    | Green
    | Blue
    | Indigo
    | Violet


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
    , Orange
    , Yellow
    , Green
    , Blue
    , Indigo
    , Violet
    ]


colorToString : Color -> String
colorToString c =
    case c of
        Red ->
            "Red"

        Orange ->
            "Orange"

        Yellow ->
            "Yellow"

        Green ->
            "Green"

        Blue ->
            "Blue"

        Indigo ->
            "Indigo"

        Violet ->
            "Violet"


{-| Your model should store the selected item and the state of the Select component(s)
-}
initialModel : String -> Model
initialModel id =
    { id = id
    , colors = colors
    , selectedColors = []
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
    Select.newConfig OnSelect colorToString
        |> Select.withOnRemoveItem OnRemoveItem
        |> Select.withCutoff 12
        |> Select.withInputId "input-id"
        |> Select.withInputWrapperStyles
            [ ( "padding", "0.4rem" ) ]
        |> Select.withItemClass "border-bottom border-silver p1 gray"
        |> Select.withItemStyles [ ( "font-size", "1rem" ) ]
        |> Select.withMenuClass "border border-gray"
        |> Select.withMenuStyles [ ( "background", "white" ) ]
        |> Select.withNotFound "No matches"
        |> Select.withNotFoundClass "red"
        |> Select.withNotFoundStyles [ ( "padding", "0 2rem" ) ]
        |> Select.withHighlightedItemClass "bg-silver"
        |> Select.withHighlightedItemStyles []
        |> Select.withPrompt "Select a color"
        |> Select.withPromptClass "grey"
        |> Select.withUnderlineClass "underline"


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
    div [ class "bg-silver p1" ]
        [ h3 [] [ text "MultiSelect example" ]
        , text (String.join ", " <| List.map colorToString model.selectedColors)

        -- Render the Select view. You must pass:
        -- - The configuration
        -- - A unique identifier for the select component
        -- - The Select internal state
        -- - A list of items
        -- - The currently selected item as Maybe
        , h4 [] [ text "Pick colors" ]
        , Html.map SelectMsg
            (Select.viewMulti selectConfig
                model.selectState
                model.colors
                model.selectedColors
            )
        ]
