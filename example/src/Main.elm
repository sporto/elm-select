module Main exposing (..)

import Html exposing (Html, text, div, program)
import Select


type alias Model =
    { message : String
    }


type alias Movie =
    { id : String
    , label : String
    }


init : ( Model, Cmd Msg )
init =
    ( { message = "Your Elm App is working!" }, Cmd.none )


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


autoCompleteOptions =
    [ Movie "1" "Harry Potter" ]


view : Model -> Html Msg
view model =
    div [] [ Select.view autoCompleteConfig autoCompleteOptions ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
