module Example1 exposing (..)

import Html exposing (Html, text, div)
import Movies
import Select


type alias Movie =
    { id : String
    , label : String
    }


type alias Model =
    { movies : List Movie
    , selectedMovieId : Maybe String
    }


movies : List Movie
movies =
    List.map (\( id, name ) -> Movie id name) Movies.movies


initialModel : Model
initialModel =
    { movies = movies
    , selectedMovieId = Nothing
    }


type Msg
    = NoOp
    | OnQuery String
    | OnSelect Movie


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnQuery str ->
            ( model, Cmd.none )

        OnSelect movie ->
            ( { model | selectedMovieId = Just movie.id }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


autoCompleteConfig : Select.Config Msg Movie
autoCompleteConfig =
    { onQueryChange = OnQuery
    , onSelect = OnSelect
    , toLabel = .label
    }


view : Model -> Html Msg
view model =
    div [] [ Select.view autoCompleteConfig model.movies ]
