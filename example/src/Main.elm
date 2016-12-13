module Main exposing (..)

import Example1
import Html exposing (..)
import Html.Attributes exposing (class)


type alias Model =
    { example1a : Example1.Model
    , example1b : Example1.Model
    }


initialModel : Model
initialModel =
    { example1a = Example1.initialModel
    , example1b = Example1.initialModel
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


type Msg
    = NoOp
    | Example1aMsg Example1.Msg
    | Example1bMsg Example1.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Example1aMsg sub ->
            let
                ( subModel, subCmd ) =
                    Example1.update sub model.example1a
            in
                ( { model | example1a = subModel }, Cmd.map Example1aMsg subCmd )

        Example1bMsg sub ->
            let
                ( subModel, subCmd ) =
                    Example1.update sub model.example1b
            in
                ( { model | example1b = subModel }, Cmd.map Example1bMsg subCmd )

        NoOp ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "p3" ]
        [ h1 [] [ text "Elm Select" ]
        , div [ class "clearfix" ]
            [ div [ class "col col-6" ]
                [ Html.map Example1aMsg (Example1.view model.example1a)
                ]
            , div [ class "col col-6" ]
                [ Html.map Example1bMsg (Example1.view model.example1b)
                ]
            ]
        ]


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
