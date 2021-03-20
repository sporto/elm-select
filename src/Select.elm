module Select exposing
    ( RequiredConfig, Config, State, Msg
    , newConfig, withCustomInput, withCutoff, withOnQuery, withEmptySearch, withTransformQuery
    , withMultiSelection, withOnRemoveItem, withMultiInputItemContainerAttrs, withMultiInputItemAttrs
    , withInputControlAttrs
    , withInputWrapperAttrs
    , withInputAttrs, withOnFocus
    , withClear, withClearAttrs, withClearSvgAttrs, withClearHtml
    , withItemAttrs, withItemHtml, withHighlightedItemAttrs
    , withMenuAttrs
    , withNotFound, withNotFoundAttrs, withNotFoundShown
    , withPrompt, withPromptAttrs
    , newState, queryFromState
    , view
    , update
    )

{-| Select input with auto-complete

See a full example of the select input [here](https://github.com/sporto/elm-select/blob/master/demo/src/Example1Basic.elm)

See a full example of the select input in multi mode [here](https://github.com/sporto/elm-select/blob/master/demo/src/Example3Multi.elm)

See live demo [here](https://sporto.github.io/elm-select)


# Types

@docs RequiredConfig, Config, State, Msg


# Configuration

@docs newConfig, withCustomInput, withCutoff, withOnQuery, withEmptySearch, withTransformQuery


# Configure Multi Select mode

@docs withMultiSelection, withOnRemoveItem, withMultiInputItemContainerAttrs, withMultiInputItemAttrs


# Configure the input control

This is the container that wraps the entire select view

@docs withInputControlAttrs


# Configure the input wapper

This is the element that wraps the selected item(s) and the input

@docs withInputWrapperAttrs


# Configure the input

@docs withInputAttrs, withOnFocus


# Configure the clear button

@docs withClear, withClearAttrs, withClearSvgAttrs, withClearHtml


# Configure the items

@docs withItemAttrs, withItemHtml, withHighlightedItemAttrs


# Configure the menu

@docs withMenuAttrs


# Configure the not found message

@docs withNotFound, withNotFoundAttrs, withNotFoundShown


# Configure the prompt

@docs withPrompt, withPromptAttrs


# State

@docs newState, queryFromState


# View

@docs view


# Update

@docs update

-}

import Html exposing (..)
import Select.Config as Config
import Select.Messages as Messages
import Select.Models as Models
import Select.Select
import Select.Update


{-| Required initial configuration

  - onSelect: A message to trigger when an item is selected
  - toLabel: A function to get a label to display from an item
  - filter: A function that takes the typed query and the list of all items, and return the filtered items.

-}
type alias RequiredConfig msg item =
    { filter : String -> List item -> Maybe (List item)
    , toLabel : item -> String
    , onSelect : Maybe item -> msg
    , toMsg : Msg item -> msg
    }


{-| Opaque type that holds all the configuration
-}
type Config msg item
    = PrivateConfig (Config.Config msg item)


{-| Opaque type that holds the current state
-}
type State
    = PrivateState Models.State


{-| Opaque type for internal library messages
-}
type Msg item
    = PrivateMsg (Messages.Msg item)


{-| Create a new configuration. This takes as `RequiredConfig` record.
-}
newConfig : RequiredConfig msg item -> Config msg item
newConfig requiredConfig =
    Config.newConfig
        { onSelect = requiredConfig.onSelect
        , toLabel = requiredConfig.toLabel
        , filter = requiredConfig.filter
        , toMsg = PrivateMsg >> requiredConfig.toMsg
        }
        |> PrivateConfig


{-| Show results if the input is focused, but the query is empty.
Similar to a dropdown, focusing on the input will show the menu.

Default is False.

    Select.withEmptySearch True config

-}
withEmptySearch : Bool -> Config msg item -> Config msg item
withEmptySearch emptySearch config =
    let
        fn c =
            { c | emptySearch = emptySearch }
    in
    mapConfig fn config


{-| Add attrs to the input control

    Select.withInputControlAttrs "control-class" config

-}
withInputControlAttrs :
    List (Attribute msg)
    -> Config msg item
    -> Config msg item
withInputControlAttrs attrs config =
    let
        fn c =
            { c | inputControlAttrs = attrs }
    in
    mapConfig fn config


{-| Remove the clear button entirely

    Select.withClear False

-}
withClear : Bool -> Config msg item -> Config msg item
withClear value config =
    let
        fn c =
            { c | hasClear = value }
    in
    mapConfig fn config


{-| Add attributes to the clear button

    Select.withClearAttrs [ class "clear" ] config

-}
withClearAttrs :
    List (Attribute msg)
    -> Config msg item
    -> Config msg item
withClearAttrs attrs config =
    let
        fn c =
            { c | clearAttrs = attrs }
    in
    mapConfig fn config


{-| Add attributes to the clear SVG icon

    Select.withClearSvgAttrs [ class "clear" ] config

-}
withClearSvgAttrs :
    List (Attribute msg)
    -> Config msg item
    -> Config msg item
withClearSvgAttrs attrs config =
    let
        fn c =
            { c | clearSvgAttrs = attrs }
    in
    mapConfig fn config


{-| Use your own html for the clear icon

    Select.withClearHtml (Just (text "X")) config

-}
withClearHtml :
    Maybe (Html msg)
    -> Config msg item
    -> Config msg item
withClearHtml html config =
    let
        fn c =
            { c | clearHtml = html }
    in
    mapConfig fn config


{-| Allow users to write a custom values (free text entry)
You must provide a function that converst a String into an item

    Select.withCustomInput (\string -> item) config

-}
withCustomInput : (String -> item) -> Config msg item -> Config msg item
withCustomInput toItem config =
    let
        fn c =
            { c | customInput = Just toItem }
    in
    mapConfig fn config


{-| Set the maxium number of items to show

    Select.withCutoff 6 config

-}
withCutoff : Int -> Config msg item -> Config msg item
withCutoff n config =
    let
        fn c =
            { c | cutoff = Just n }
    in
    mapConfig fn config


{-| Add attributes to the input

    Select.withInputAttrs [ class "col-12" ] config

-}
withInputAttrs :
    List (Attribute msg)
    -> Config msg item
    -> Config msg item
withInputAttrs attrs config =
    let
        fn c =
            { c | inputAttrs = attrs }
    in
    mapConfig fn config


{-| Add attributes to the input wrapper (element that wraps the input and the clear button)

    Select.withInputWrapperAttrs [ class "col-12" ] config

-}
withInputWrapperAttrs : List (Attribute msg) -> Config msg item -> Config msg item
withInputWrapperAttrs attrs config =
    let
        fn c =
            { c | inputWrapperAttrs = attrs }
    in
    mapConfig fn config


{-| Add attributes to the items

    Select.withItemAttrs [ class "border-bottom" ] config

-}
withItemAttrs :
    List (Attribute msg)
    -> Config msg item
    -> Config msg item
withItemAttrs attrs config =
    let
        fn c =
            { c | itemAttrs = attrs }
    in
    mapConfig fn config


{-| Custom item element HTML

    Select.withItemHtml (\i -> Html.li [] [ text i ]) config

When this is used the original `toLabel` function in the config is ignored.

-}
withItemHtml :
    (item -> Html msg)
    -> Config msg item
    -> Config msg item
withItemHtml html config =
    let
        fn c =
            { c | itemHtml = Just html }
    in
    mapConfig fn config


{-| Add attributes to the menu

    Select.withMenuAttrs [ class "bg-white" ] config

-}
withMenuAttrs :
    List (Attribute msg)
    -> Config msg item
    -> Config msg item
withMenuAttrs attrs config =
    let
        fn c =
            { c | menuAttrs = attrs }
    in
    mapConfig fn config


{-| Message to call when removing an individual item. Please note that without this option
specified, you will not be able to remove an individual item from MultiSelect mode.

    Select.withOnRemoveItem OnRemoveItem

-}
withOnRemoveItem : (item -> msg) -> Config msg item -> Config msg item
withOnRemoveItem onRemoveItemMsg config =
    let
        fn c =
            { c | onRemoveItem = Just onRemoveItemMsg }
    in
    mapConfig fn config


{-| Add attributes to the container of selected items

    Select.withMultiInputItemContainerAttrs [ class "bg-white" ] config

-}
withMultiInputItemContainerAttrs :
    List (Attribute msg)
    -> Config msg item
    -> Config msg item
withMultiInputItemContainerAttrs attrs config =
    let
        fn c =
            { c | multiInputItemContainerAttrs = attrs }
    in
    mapConfig fn config


{-| Add attributes to an individual selected item

    config
        |> Select.withMultiInputItemAttrs [ class "bg-white" ]

-}
withMultiInputItemAttrs :
    List (Attribute msg)
    -> Config msg item
    -> Config msg item
withMultiInputItemAttrs attrs config =
    let
        fn c =
            { c | multiInputItemAttrs = attrs }
    in
    mapConfig fn config


{-| Use a multi select instead of a single select
-}
withMultiSelection : Bool -> Config msg item -> Config msg item
withMultiSelection value config =
    config
        |> mapConfig
            (\c ->
                { c | isMultiSelect = value }
            )


{-| Text that will appear when no matches are found

    Select.withNotFound "No matches" config

-}
withNotFound : String -> Config msg item -> Config msg item
withNotFound text config =
    let
        fn c =
            { c | notFound = text }
    in
    mapConfig fn config


{-| Attributes for the not found message

    Select.withNotFoundAttrs [ class "red" ] config

-}
withNotFoundAttrs :
    List (Attribute msg)
    -> Config msg item
    -> Config msg item
withNotFoundAttrs attrs config =
    let
        fn c =
            { c | notFoundAttrs = attrs }
    in
    mapConfig fn config


{-| Hide menu when no matches found

    Select.withNotFoundShown False config

-}
withNotFoundShown : Bool -> Config msg item -> Config msg item
withNotFoundShown shown config =
    let
        fn c =
            { c | notFoundShown = shown }
    in
    mapConfig fn config


{-| Attributes for the hightlighted tem

    Select.withHighlightedItemAttrs [ class "red" ] config

-}
withHighlightedItemAttrs :
    List (Attribute msg)
    -> Config msg item
    -> Config msg item
withHighlightedItemAttrs attrs config =
    let
        fn c =
            { c | highlightedItemAttrs = attrs }
    in
    mapConfig fn config


{-| Add a callback for when the query changes

    Select.withOnQuery OnQuery

-}
withOnQuery : (String -> msg) -> Config msg item -> Config msg item
withOnQuery msg config =
    let
        fn c =
            { c | onQueryChange = Just msg }
    in
    mapConfig fn config


{-| Add a callback for when the input field receives focus

    Select.withOnFocus OnFocus

-}
withOnFocus : msg -> Config msg item -> Config msg item
withOnFocus msg config =
    let
        fn c =
            { c | onFocus = Just msg }
    in
    mapConfig fn config


{-| Add attributes to the prompt text (When no item is selected)
Select.withPromptAttrs "prompt" config
-}
withPromptAttrs :
    List (Attribute msg)
    -> Config msg item
    -> Config msg item
withPromptAttrs attrs config =
    let
        fn c =
            { c | promptAttrs = attrs }
    in
    mapConfig fn config


{-| Add a prompt text to be displayed when no element is selected

    Select.withPrompt "Select a movie" config

-}
withPrompt : String -> Config msg item -> Config msg item
withPrompt prompt config =
    let
        fn c =
            { c | prompt = prompt }
    in
    mapConfig fn config


{-| Transform the input query before performing the search
Return Nothing to prevent searching

    transform : String -> Maybe String
    transform query =
        if String.length query < 4 then
            Nothing
        else
            Just query

    Select.withTransformQuery transform config

-}
withTransformQuery : (String -> String) -> Config msg item -> Config msg item
withTransformQuery transform config =
    let
        fn c =
            { c | transformQuery = transform }
    in
    mapConfig fn config


{-| @priv
-}
mapConfig : (Config.Config msg item -> Config.Config msg item) -> Config msg item -> Config msg item
mapConfig fn config =
    let
        config_ =
            unwrapConfig config
    in
    PrivateConfig (fn config_)


{-| Create a new state. You must pass a unique identifier for each select component.

    {
        ...
        selectState = Select.newState "select1"
    }

-}
newState : String -> State
newState id =
    PrivateState (Models.newState id)


{-| Return the query string from the current state model

    Select.queryFromState model.selectState

-}
queryFromState : State -> Maybe String
queryFromState model =
    model
        |> unwrapModel
        |> .query


{-| Render the view

    Select.view
        selectConfig
        model.selectState
        model.items
        selectedItems

-}
view :
    Config msg item
    -> State
    -> List item
    -> List item
    -> Html msg
view config model items selected =
    Select.Select.view
        (unwrapConfig config)
        (unwrapModel model)
        items
        selected


{-| Update the component state

    SelectMsg subMsg ->
        let
            ( updated, cmd ) =
                Select.update selectConfig subMsg model.selectState
        in
            ( { model | selectState = updated }, cmd )

-}
update : Config msg item -> Msg item -> State -> ( State, Cmd msg )
update config msg model =
    let
        config_ =
            unwrapConfig config

        msg_ =
            unwrapMsg msg

        model_ =
            unwrapModel model
    in
    let
        ( mdl, cmd ) =
            Select.Update.update config_ msg_ model_
    in
    ( PrivateState mdl, cmd )


{-| @priv
-}
unwrapConfig : Config msg item -> Config.Config msg item
unwrapConfig config =
    case config of
        PrivateConfig c ->
            c


{-| @priv
-}
unwrapMsg : Msg item -> Messages.Msg item
unwrapMsg msg =
    case msg of
        PrivateMsg m ->
            m


{-| @priv
-}
unwrapModel : State -> Models.State
unwrapModel model =
    case model of
        PrivateState m ->
            m
