module Example4Custom exposing
    ( Model
    , Movie
    , Msg(..)
    , initialModel
    , movies
    , update
    , view
    )

import Html exposing (..)
import Html.Attributes exposing (class)
import Movies
import Select
import Shared


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
    , selectedMovieId : Maybe String
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
    , selectedMovieId = Nothing
    , selectState = Select.newState id
    }


type Msg
    = NoOp
    | OnSelect (Maybe Movie)
    | SelectMsg (Select.Msg Movie)


{-| Your update function should route messages back to the Select component, see `SelectMsg`.
-}
update : Select.Config Msg Movie -> Msg -> Model -> ( Model, Cmd Msg )
update selectConfig msg model =
    case msg of
        -- OnSelect is triggered when a selection is made on the Select component.
        OnSelect maybeMovie ->
            let
                maybeId =
                    Maybe.map .id maybeMovie
            in
            ( { model | selectedMovieId = maybeId }, Cmd.none )

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
view : Select.Config Msg Movie -> Model -> String -> Html Msg
view selectConfig model title =
    let
        currentSelection =
            p [ class "mt-2" ]
                ([ text "Current selection: "
                 ]
                    ++ selectedMovieList
                )

        selectedMovieList : List (Html msg)
        selectedMovieList =
            List.map
                (\movie ->
                    span []
                        [ text movie.id
                        , text " "
                        , text movie.label
                        ]
                )
                selectedMovies

        selectedMovies : List Movie
        selectedMovies =
            case model.selectedMovieId of
                Nothing ->
                    []

                Just id ->
                    List.filter (\movie -> movie.id == id) movies

        select =
            Select.view
                selectConfig
                model.selectState
                model.movies
                selectedMovies
    in
    div [ class "bg-gray-300 p-2" ]
        [ h3 [] [ text title ]
        , currentSelection
        , p [ class "mt-2" ]
            [ label [] [ text "Pick a movie" ]
            ]
        , p []
            [ select
            ]
        ]
