module Example3 exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Movies
import Select


{-| Model to be passed to the select component. You model can be anything.
E.g. Records, tuples or just strings.
-}
type alias Movie =
    { id : String
    , label : String
    }


{-| In your main application model you should store:

  - The selected item e.g. selectedMovieId
  - The state for the select component e.g. selectState

-}
type alias Model =
    { id : String
    , movies : List Movie
    , selectedMovies : List Movie
    , selectState : Select.State
    }


{-| A helper function that transforms a list of tuples into records
-}
movies : List Movie
movies =
    List.map (\( id, name ) -> Movie id name) Movies.movies


{-| Your model should store the selected item and the state of the Select component(s)
-}
initialModel : String -> Model
initialModel id =
    { id = id
    , movies = movies
    , selectedMovies = []
    , selectState = Select.newState id
    }


{-| Your application messages need to include:

  - OnSelect item : This will be called when an item is selected
  - SelectMsg (Select.Msg item) : A message that wraps internal Select library messages. This is necessary to route messages back to the component.

-}
type Msg
    = NoOp
    | OnSelect (Maybe Movie)
    | SelectMsg (Select.Msg Movie)


{-| Create the configuration for the Select component

`Select.newConfig` takes two args:

  - The selection message e.g. `OnSelect`
  - A function that extract a label from an item e.g. `.label`

All the functions after |> are optional configuration.

-}
selectConfig : Select.Config Msg Movie
selectConfig =
    Select.newConfig OnSelect .label
        |> Select.withCutoff 12
        |> Select.withInputId "input-id"
        |> Select.withInputWrapperClass "col-12"
        |> Select.withInputWrapperStyles
            [ ( "padding", "0.5rem" ), ( "outline", "none" ) ]
        |> Select.withItemClass "border-bottom border-silver p1 gray"
        |> Select.withItemStyles [ ( "font-size", "1rem" ) ]
        |> Select.withMenuClass "border border-gray"
        |> Select.withMenuStyles [ ( "background", "white" ) ]
        |> Select.withNotFound "No matches"
        |> Select.withNotFoundClass "red"
        |> Select.withNotFoundStyles [ ( "padding", "0 2rem" ) ]
        |> Select.withHighlightedItemClass "bg-silver"
        |> Select.withHighlightedItemStyles [ ( "color", "black" ) ]
        |> Select.withPrompt "Select a movie"
        |> Select.withPromptClass "grey"


{-| Your update function should route messages back to the Select component, see `SelectMsg`.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- OnSelect is triggered when a selection is made on the Select component.
        OnSelect maybeMovie ->
            let
                selectedMovies =
                    maybeMovie
                        |> Maybe.map (List.singleton >> List.append model.selectedMovies)
                        |> Maybe.withDefault []
            in
            ( { model | selectedMovies = selectedMovies }, Cmd.none )

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
        , text (toString <| List.map .id model.selectedMovies)

        -- Render the Select view. You must pass:
        -- - The configuration
        -- - A unique identifier for the select component
        -- - The Select internal state
        -- - A list of items
        -- - The currently selected item as Maybe
        , h4 [] [ text "Pick movie(s)" ]
        , Html.map SelectMsg
            (Select.viewMulti selectConfig
                model.selectState
                model.movies
                model.selectedMovies
            )
        ]
