module Example1 exposing (..)

import Html exposing (Html, text, div)
import Select


type alias Movie =
    { id : String
    , label : String
    }


type alias Model =
    { movies : List Movie
    }


initialModel : Model
initialModel =
    { movies = [ Movie "1" "Harry Potter" ]
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
            ( model, Cmd.none )

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
