module Main exposing (..)

import Example1
import Html exposing (Html, text, div, program)


type alias Model =
    { example1 : Example1.Model
    }


initialModel : Model
initialModel =
    { example1 = Example1.initialModel
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


type Msg
    = NoOp
    | Example1Msg Example1.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Example1Msg sub ->
            let
                ( subModel, subCmd ) =
                    Example1.update sub model.example1
            in
                ( { model | example1 = subModel }, Cmd.map Example1Msg subCmd )

        NoOp ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div [] [ Html.map Example1Msg (Example1.view model.example1) ]


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
