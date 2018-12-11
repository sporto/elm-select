module Main exposing (main)

import Browser
import Example1Basic
import Example2Async
import Example3Multi
import Html exposing (..)
import Html.Attributes exposing (class, href)


type alias Model =
    { example1a : Example1Basic.Model
    , example1b : Example1Basic.Model
    , example2 : Example2Async.Model
    , example3 : Example3Multi.Model
    }


initialModel : Model
initialModel =
    { example1a = Example1Basic.initialModel "1"
    , example1b = Example1Basic.initialModel "2"
    , example2 = Example2Async.initialModel "3"
    , example3 = Example3Multi.initialModel "4"
    }


initialCmds : Cmd Msg
initialCmds =
    Cmd.batch [ Cmd.map Example2AsyncMsg Example2Async.initialCmds ]


init : flags -> ( Model, Cmd Msg )
init _ =
    ( initialModel, initialCmds )


type Msg
    = NoOp
    | Example1BasicAMsg Example1Basic.Msg
    | Example1BasicBMsg Example1Basic.Msg
    | Example2AsyncMsg Example2Async.Msg
    | Example3MultiMsg Example3Multi.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Example1BasicAMsg sub ->
            let
                ( subModel, subCmd ) =
                    Example1Basic.update sub model.example1a
            in
            ( { model | example1a = subModel }, Cmd.map Example1BasicAMsg subCmd )

        Example1BasicBMsg sub ->
            let
                ( subModel, subCmd ) =
                    Example1Basic.update sub model.example1b
            in
            ( { model | example1b = subModel }, Cmd.map Example1BasicBMsg subCmd )

        Example2AsyncMsg sub ->
            let
                ( subModel, subCmd ) =
                    Example2Async.update sub model.example2
            in
            ( { model | example2 = subModel }, Cmd.map Example2AsyncMsg subCmd )

        Example3MultiMsg sub ->
            let
                ( subModel, subCmd ) =
                    Example3Multi.update sub model.example3
            in
            ( { model | example3 = subModel }, Cmd.map Example3MultiMsg subCmd )

        NoOp ->
            ( model, Cmd.none )


projectUrl : String
projectUrl =
    "https://github.com/sporto/elm-select"


view : Model -> Html Msg
view model =
    div [ class "p-5" ]
        [ h1 [] [ text "Elm Select" ]
        , a [ href projectUrl ] [ text projectUrl ]
        , div [ class "mt-4" ]
            [ Html.map Example1BasicAMsg (Example1Basic.view model.example1a)
            ]
        , div [ class "mt-4" ]
            [ Html.map Example1BasicBMsg (Example1Basic.view model.example1b)
            ]
        , div [ class "mt-4" ]
            [ Html.map Example2AsyncMsg (Example2Async.view model.example2)
            ]
        , div [ class "mt-4" ]
            [ Html.map Example3MultiMsg (Example3Multi.view model.example3)
            ]
        ]


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
