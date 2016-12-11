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
    , selectState : Select.Model Movie
    }


movies : List Movie
movies =
    List.map (\( id, name ) -> Movie id name) Movies.movies


initialModel : Model
initialModel =
    { movies = movies
    , selectedMovieId = Nothing
    , selectState = Select.model []
    }


type Msg
    = NoOp
    | OnQuery String
    | OnSelect Movie
    | SelectMsg (Select.Msg Movie)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnQuery str ->
            ( model, Cmd.none )

        OnSelect movie ->
            ( { model | selectedMovieId = Just movie.id }, Cmd.none )

        SelectMsg subMsg ->
            let
                updated =
                    Select.update subMsg model.selectState
            in
                ( { model | selectState = updated }, Cmd.none )

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
    let
        selectedMovie =
            case model.selectedMovieId of
                Nothing ->
                    Nothing

                Just id ->
                    List.filter (\movie -> movie.id == id) movies |> List.head
    in
        div [] [ Html.map SelectMsg (Select.view autoCompleteConfig model.selectState model.movies) ]
