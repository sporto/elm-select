module Main exposing (main)

import Browser
import ExampleAsync
import Example
import Html exposing (..)
import Html.Attributes exposing (class, href, style)
import Select
import Shared
import Color
import Movie


type alias Model =
    { exampleBasic : Example.Model Movie.Movie
    , exampleAsync : ExampleAsync.Model
    , exampleEmptySearch : Example.Model Movie.Movie
    , exampleMulti : Example.Model Color.Color
    , exampleCustom : Example.Model Movie.Movie
    }


initialModel : Model
initialModel =
    { exampleBasic = Example.initialModel
        { id = "exampleBasic"
        , available = Movie.movies
        , itemToLabel = Movie.toLabel
        , selected = [ ]
        , selectConfig = selectConfigMovie
        }
    , exampleAsync = ExampleAsync.initialModel "2"
    , exampleEmptySearch = Example.initialModel
        { id = "exampleEmptySearch"
        , available = Movie.movies
        , itemToLabel = Movie.toLabel
        , selected = [ ]
        , selectConfig = selectConfigEmptySearch
        }
    , exampleMulti = Example.initialModel
        { id = "exampleMulti"
        , available = Color.colors
        , itemToLabel = Color.toLabel
        , selected = [ Color.Red, Color.Black ]
        , selectConfig = selectConfigMulti
        }
    , exampleCustom = Example.initialModel
        { id = "exampleCustom"
        , available = Movie.movies
        , itemToLabel = Movie.toLabel
        , selected = [ ]
        , selectConfig = selectConfigCustom
        }
    }


initialCmds : Cmd Msg
initialCmds =
    Cmd.batch [ Cmd.map ExampleAsyncMsg ExampleAsync.initialCmds ]


init : flags -> ( Model, Cmd Msg )
init _ =
    ( initialModel, initialCmds )


type Msg
    = NoOp
    | ExampleBasicMsg (Example.Msg Movie.Movie)
    | ExampleAsyncMsg ExampleAsync.Msg
    | ExampleEmptySearchMsg (Example.Msg Movie.Movie)
    | ExampleMultiMsg (Example.Msg Color.Color)
    | ExampleCustomMsg (Example.Msg Movie.Movie)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ExampleBasicMsg sub ->
            let
                ( subModel, subCmd ) =
                    Example.update
                        sub
                        model.exampleBasic
            in
            ( { model | exampleBasic = subModel }
            , Cmd.map ExampleBasicMsg subCmd
            )

        ExampleAsyncMsg sub ->
            let
                ( subModel, subCmd ) =
                    ExampleAsync.update
                        sub
                        model.exampleAsync
            in
            ( { model | exampleAsync = subModel }
            , Cmd.map ExampleAsyncMsg subCmd
            )

        ExampleEmptySearchMsg sub ->
            let
                ( subModel, subCmd ) =
                    Example.update
                        sub
                        model.exampleEmptySearch
            in
            ( { model | exampleEmptySearch = subModel }
            , Cmd.map ExampleEmptySearchMsg subCmd
            )

        ExampleMultiMsg sub ->
            let
                ( subModel, subCmd ) =
                    Example.update
                        sub
                        model.exampleMulti
            in
            ( { model | exampleMulti = subModel }
            , Cmd.map ExampleMultiMsg subCmd
            )

        ExampleCustomMsg sub ->
            let
                ( subModel, subCmd ) =
                    Example.update
                        sub
                        model.exampleCustom
            in
            ( { model | exampleCustom = subModel }
            , Cmd.map ExampleCustomMsg subCmd
            )

        NoOp ->
            ( model, Cmd.none )


projectUrl : String
projectUrl =
    "https://github.com/sporto/elm-select"


view : Model -> Html Msg
view model =
    div [ ]
        [ h1 [] [ text "Elm Select" ]
        , a [ href projectUrl ] [ text projectUrl ]
        , Example.view
            model.exampleBasic
            "Default"
            "Select a movie"
            |> Html.map ExampleBasicMsg
        , ExampleAsync.view
            model.exampleAsync
            |> Html.map ExampleAsyncMsg
        , Example.view
            model.exampleEmptySearch
            "Show menu when search is empty"
            "Select a movie"
            |> Html.map ExampleEmptySearchMsg
        , Example.view
            model.exampleMulti
            "Multi"
            "Select colors"
            |> Html.map ExampleMultiMsg
        , Example.view
            model.exampleCustom
            "Free entry input"
            "Select a movie"
            |> Html.map ExampleCustomMsg
        ]


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }


selectConfigMovie : Select.Config (Example.Msg Movie.Movie) Movie.Movie
selectConfigMovie =
    Select.newConfig
        { onSelect = Example.OnSelect
        , toLabel = Movie.toLabel
        , filter = Shared.filter 2 Movie.toLabel
        , toMsg = Example.SelectMsg
        }
        |> Select.withMenuAttrs [ style "max-height" "10rem" ]


selectConfigColor : Select.Config (Example.Msg Color.Color) Color.Color
selectConfigColor =
    Select.newConfig
        { onSelect = Example.OnSelect
        , toLabel = Color.toLabel
        , filter = Shared.filter 2 Color.toLabel
        , toMsg = Example.SelectMsg
        }


selectConfigMulti =
    selectConfigColor
        |> Select.withMultiSelection True
        |> Select.withOnRemoveItem Example.OnRemoveItem
        |> Select.withCutoff 12
        |> Select.withNotFound "No matches"
        |> Select.withPrompt "Select a color"


selectConfigEmptySearch =
    Select.newConfig
        { onSelect = Example.OnSelect
        , toLabel = .label
        , filter = Shared.filter 4 .label
        , toMsg = Example.SelectMsg
        }
        |> Select.withCutoff 12
        |> Select.withEmptySearch True
        |> Select.withNotFound "No matches"
        |> Select.withPrompt "Select a movie"
        |> Select.withClearHtml (Just (text "X"))


selectConfigCustom =
    selectConfigMovie
        |> Select.withCustomInput
            (\input ->
                { id = input
                , label = input
                }
            )
