module Select.Update exposing (..)

import Select.Models as Models
import Select.Messages exposing (..)
import Task


update : Models.Config msg item -> Msg item -> Models.State -> ( Models.State, Cmd msg )
update config msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        OnEsc ->
            ( { model | query = Nothing }, Cmd.none )

        OnDownArrow ->
            let
                newHightlightedItem =
                  case model.highlightedItem of
                    Nothing -> Just 0
                    Just n -> Just (n + 1)
            in
              ( { model | highlightedItem =  newHightlightedItem }, Cmd.none )

        OnUpArrow ->
            let
                newHightlightedItem =
                  case model.highlightedItem of
                    Nothing -> Nothing
                    Just 0 -> Nothing
                    Just n -> Just (n - 1)
            in
              ( { model | highlightedItem =  newHightlightedItem }, Cmd.none)

        OnBlur ->
            ( { model | query = Nothing }, Cmd.none )

        OnClear ->
            let
                cmd =
                    Task.succeed Nothing
                        |> Task.perform config.onSelect
            in
                ( { model | query = Nothing }, cmd )

        OnQueryChange value ->
            let
                cmd =
                    case config.onQueryChange of
                        Nothing ->
                            Cmd.none

                        Just constructor ->
                            Task.succeed value
                                |> Task.perform constructor
            in
                ( { model | highlightedItem = Nothing, query = Just value }, cmd )

        OnSelect item ->
            let
                cmd =
                    Task.succeed (Just item)
                        |> Task.perform config.onSelect
            in
                ( { model | query = Nothing }, cmd )
