module Main exposing (main)

import Browser
import Example1Basic
import Example2Async
import Example3Multi
import Example4Custom
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Select
import Shared


type alias Model =
    { example1a : Example1Basic.Model
    , example1b : Example1Basic.Model
    , example2 : Example2Async.Model
    , example3 : Example3Multi.Model
    , example4a : Example4Custom.Model
    , example4b : Example4Custom.Model
    , example4c : Example4Custom.Model
    }


initialModel : Model
initialModel =
    { example1a = Example1Basic.initialModel "1a"
    , example1b = Example1Basic.initialModel "1b"
    , example2 = Example2Async.initialModel "2"
    , example3 = Example3Multi.initialModel "3"
    , example4a = Example4Custom.initialModel "4a"
    , example4b = Example4Custom.initialModel "4b"
    , example4c = Example4Custom.initialModel "4c"
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
    | Example4CustomAMsg Example4Custom.Msg
    | Example4CustomBMsg Example4Custom.Msg
    | Example4CustomCMsg Example4Custom.Msg


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

        Example4CustomAMsg sub ->
            let
                ( subModel, subCmd ) =
                    Example4Custom.update
                        selectConfig4a
                        sub
                        model.example4a
            in
            ( { model | example4a = subModel }, Cmd.map Example4CustomAMsg subCmd )

        Example4CustomBMsg sub ->
            let
                ( subModel, subCmd ) =
                    Example4Custom.update
                        selectConfig4b
                        sub
                        model.example4b
            in
            ( { model | example4b = subModel }, Cmd.map Example4CustomBMsg subCmd )

        Example4CustomCMsg sub ->
            let
                ( subModel, subCmd ) =
                    Example4Custom.update
                        selectConfig4c
                        sub
                        model.example4c
            in
            ( { model | example4c = subModel }, Cmd.map Example4CustomCMsg subCmd )

        NoOp ->
            ( model, Cmd.none )


projectUrl : String
projectUrl =
    "https://github.com/sporto/elm-select"


view : Model -> Html Msg
view model =
    div [ class "p-5 pb-20" ]
        [ h1 [] [ text "Elm Select" ]
        , a [ href projectUrl ] [ text projectUrl ]
        , Html.map Example1BasicAMsg (Example1Basic.view model.example1a)
        , Html.map Example1BasicBMsg (Example1Basic.view model.example1b)
        , Html.map Example2AsyncMsg (Example2Async.view model.example2)
        , Html.map Example3MultiMsg (Example3Multi.view model.example3)
        , Example4Custom.view
                selectConfig4a
                model.example4a
                "With empty search"
                |> Html.map Example4CustomAMsg
        , Example4Custom.view
                selectConfig4b
                model.example4b
                "With custom input"
                |> Html.map Example4CustomBMsg
        , Example4Custom.view
                selectConfig4c
                model.example4c
                "Just the defaults"
                |> Html.map Example4CustomCMsg
        ]


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }


selectConfig4a : Select.Config Example4Custom.Msg Example4Custom.Movie
selectConfig4a =
    Select.newConfig
        { onSelect = Example4Custom.OnSelect
        , toLabel = .label
        , filter = Shared.filter 4 .label
        , toMsg = Example4Custom.SelectMsg
        }
        |> Select.withCutoff 12
        |> Select.withEmptySearch True
        |> Select.withInputAttrs
            [ class  "border border-gray-800 p-2" ]
        |> Select.withItemAttrs
            [ class  " p-2 border-b border-gray-500 text-gray-800" ]
        |> Select.withMenuAttrs
            [ class  "border border-gray-800 bg-white" ]
        |> Select.withNotFound "No matches"
        |> Select.withNotFoundAttrs
            [ class  "text-red" ]
        |> Select.withHighlightedItemAttrs
            [ class  "demo-box" ]
        |> Select.withPrompt "Select a movie"
        |> Select.withPromptAttrs
            [ class  "text-gray-800" ]


selectConfig4b =
    selectConfig4a
        |> Select.withCustomInput
            (\input ->
                { id = input
                , label = input
                }
            )


selectConfig4c : Select.Config Example4Custom.Msg Example4Custom.Movie
selectConfig4c =
    Select.newConfig
        { onSelect = Example4Custom.OnSelect
        , toLabel = .label
        , filter = Shared.filter 4 .label
        , toMsg = Example4Custom.SelectMsg
        }
