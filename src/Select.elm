module Select exposing
    ( RequiredConfig, Config, State, Msg
    , newConfig, withCustomInput, withCutoff, withOnQuery, withEmptySearch, withTransformQuery, withTransformInput
    , withMultiSelection, withOnRemoveItem, withMultiInputItemContainerAttrs, withMultiInputItemContainerMoreAttrs, withMultiInputItemAttrs, withMultiInputItemMoreAttrs
    , withInputWrapperAttrs, withInputWrapperMoreAttrs
    , withInputAttrs, withInputMoreAttrs, withOnFocus, withOnBlur, withOnEsc, withValueSeparators
    , withClear, withClearAttrs, withClearMoreAttrs, withClearSvgClass, withClearHtml
    , withItemAttrs, withItemMoreAttrs, withItemHtml, withHighlightedItemAttrs, withHighlightedItemMoreAttrs, withItemSelectedAttrs, withItemSelectedMoreAttrs
    , withMenuAttrs, withMenuMoreAttrs
    , withNotFound, withNotFoundAttrs, withNotFoundMoreAttrs, withNotFoundShown
    , withPrompt, withPromptAttrs, withPromptMoreAttrs
    , init, queryFromState, withQuery
    , view
    , update
    , withMultiInputItemRemoveable
    )

{-| Select input with auto-complete

See a full example of the select input [here](https://github.com/sporto/elm-select/blob/master/demo/src/Example1Basic.elm)

See a full example of the select input in multi mode [here](https://github.com/sporto/elm-select/blob/master/demo/src/Example3Multi.elm)

See live demo [here](https://sporto.github.io/elm-select)


# Types

@docs RequiredConfig, Config, State, Msg


# Configuration

@docs newConfig, withCustomInput, withCutoff, withOnQuery, withEmptySearch, withTransformQuery, withTransformInput


# Configure Multi Select mode

@docs withMultiSelection, withOnRemoveItem, withMultiInputItemContainerAttrs, withMultiInputItemContainerMoreAttrs, withMultiInputItemAttrs, withMultiInputItemMoreAttrs


# Configure the input wapper

This is the element that wraps the selected item(s) and the input

@docs withInputWrapperAttrs, withInputWrapperMoreAttrs


# Configure the input

@docs withInputAttrs, withInputMoreAttrs, withOnFocus, withOnBlur, withOnEsc, withValueSeparators


# Configure the clear button

@docs withClear, withClearAttrs, withClearMoreAttrs, withClearSvgClass, withClearHtml


# Configure the items

@docs withItemAttrs, withItemMoreAttrs, withItemHtml, withHighlightedItemAttrs, withHighlightedItemMoreAttrs, withItemSelectedAttrs, withItemSelectedMoreAttrs


# Configure the menu

@docs withMenuAttrs, withMenuMoreAttrs


# Configure the not found message

@docs withNotFound, withNotFoundAttrs, withNotFoundMoreAttrs, withNotFoundShown


# Configure the prompt

@docs withPrompt, withPromptAttrs, withPromptMoreAttrs


# State

@docs init, queryFromState, withQuery


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


{-| Remove the clear button entirely

    config
        |> Select.withClear False

-}
withClear : Bool -> Config msg item -> Config msg item
withClear value config =
    let
        fn c =
            { c | hasClear = value }
    in
    mapConfig fn config


{-| Set attributes for the clear button.
This overrides any attributes already set in a previous call.

    config
        |> Select.withClearAttrs [ class "clear" ]

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


{-| Add attributes to the clear button.
This adds to existing attributes.

    config
        |> Select.withClearMoreAttrs [ class "clear" ]

-}
withClearMoreAttrs :
    List (Attribute msg)
    -> Config msg item
    -> Config msg item
withClearMoreAttrs attrs config =
    let
        fn c =
            { c | clearAttrs = c.clearAttrs ++ attrs }
    in
    mapConfig fn config


{-| Set classes for the clear SVG icon

    config
        |> Select.withClearSvgClass "clear"

-}
withClearSvgClass :
    String
    -> Config msg item
    -> Config msg item
withClearSvgClass class config =
    let
        fn c =
            { c | clearSvgClass = class }
    in
    mapConfig fn config


{-| Use your own html for the clear icon

    config
        |> Select.withClearHtml (Just (text "X"))

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

    config
        |> Select.withCustomInput (\string -> item)

-}
withCustomInput : (String -> item) -> Config msg item -> Config msg item
withCustomInput toItem config =
    let
        fn c =
            { c | customInput = Just toItem }
    in
    mapConfig fn config


{-| Set the maxium number of items to show

    config
        |> Select.withCutoff 6

-}
withCutoff : Int -> Config msg item -> Config msg item
withCutoff n config =
    let
        fn c =
            { c | cutoff = Just n }
    in
    mapConfig fn config


{-| Set attributes for the input.
This overrides any attributes already set in a previous call.

    config
        |> Select.withInputAttrs [ class "col-12" ]

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


{-| Add attributes to the input.
This adds to existing attributes.

    config
        |> Select.withInputMoreAttrs [ class "col-12" ]

-}
withInputMoreAttrs :
    List (Attribute msg)
    -> Config msg item
    -> Config msg item
withInputMoreAttrs attrs config =
    let
        fn c =
            { c | inputAttrs = c.inputAttrs ++ attrs }
    in
    mapConfig fn config


{-| Set attributes for the input wrapper (element that wraps the input and the clear button).
This overrides any attributes already set in a previous call.

    config
        |> Select.withInputWrapperAttrs [ class "col-12" ]

-}
withInputWrapperAttrs : List (Attribute msg) -> Config msg item -> Config msg item
withInputWrapperAttrs attrs config =
    let
        fn c =
            { c | inputWrapperAttrs = attrs }
    in
    mapConfig fn config


{-| Add attributes to the input wrapper (element that wraps the input and the clear button).
This adds to existing attributes.

    config
        |> Select.withInputWrapperMoreAttrs [ class "col-12" ]

-}
withInputWrapperMoreAttrs : List (Attribute msg) -> Config msg item -> Config msg item
withInputWrapperMoreAttrs attrs config =
    let
        fn c =
            { c | inputWrapperAttrs = c.inputWrapperAttrs ++ attrs }
    in
    mapConfig fn config


{-| Set attributes for the items.
This overrides any attributes already set in a previous call.

    config
        |> Select.withItemAttrs [ class "border-bottom" ]

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


{-| Add attributes to the items.
This adds to existing attributes.

    config
        |> Select.withItemMoreAttrs [ class "border-bottom" ]

-}
withItemMoreAttrs :
    List (Attribute msg)
    -> Config msg item
    -> Config msg item
withItemMoreAttrs attrs config =
    let
        fn c =
            { c | itemAttrs = c.itemAttrs ++ attrs }
    in
    mapConfig fn config


{-| Custom item element HTML

    config
        |> Select.withItemHtml (\i -> Html.li [] [ text i ])

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


{-| Set attributes for the menu.
This overrides any attributes already set in a previous call.

    config
        |> Select.withMenuAttrs [ class "bg-white" ]

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


{-| Add attributes to the menu.
This adds to existing attributes.

    config
        |> Select.withMenuMoreAttrs [ class "bg-white" ]

-}
withMenuMoreAttrs :
    List (Attribute msg)
    -> Config msg item
    -> Config msg item
withMenuMoreAttrs attrs config =
    let
        fn c =
            { c | menuAttrs = c.menuAttrs ++ attrs }
    in
    mapConfig fn config


{-| Message to call when removing an individual item. Please note that without this option
specified, you will not be able to remove an individual item from MultiSelect mode.

    config
        |> Select.withOnRemoveItem OnRemoveItem

-}
withOnRemoveItem : (item -> msg) -> Config msg item -> Config msg item
withOnRemoveItem onRemoveItemMsg config =
    let
        fn c =
            { c | onRemoveItem = Just onRemoveItemMsg }
    in
    mapConfig fn config


{-| Set attributes for the container of selected items.

    config
        |> Select.withMultiInputItemContainerAttrs [ class "bg-white" ]

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


{-| Add attributes for the container of selected items.
This adds to existing attributes.

    config
        |> Select.withMultiInputItemContainerAttrs [ class "bg-white" ]

-}
withMultiInputItemContainerMoreAttrs :
    List (Attribute msg)
    -> Config msg item
    -> Config msg item
withMultiInputItemContainerMoreAttrs attrs config =
    let
        fn c =
            { c | multiInputItemContainerAttrs = c.multiInputItemContainerAttrs ++ attrs }
    in
    mapConfig fn config


{-| Set attributes for an individual selected item.

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


{-| Add attributes to an individual selected item.
This adds to existing attributes.

    config
        |> Select.withMultiInputItemMoreAttrs [ class "bg-white" ]

-}
withMultiInputItemMoreAttrs :
    List (Attribute msg)
    -> Config msg item
    -> Config msg item
withMultiInputItemMoreAttrs attrs config =
    let
        fn c =
            { c | multiInputItemAttrs = c.multiInputItemAttrs ++ attrs }
    in
    mapConfig fn config


{-| Which items are removeable from the list

    config
        |> Select.withMultiInputItemRemoveable (\x -> x.removeable)

-}
withMultiInputItemRemoveable :
    (item -> Bool)
    -> Config msg item
    -> Config msg item
withMultiInputItemRemoveable value config =
    let
        fn c =
            { c | multiInputItemRemoveable = Just value }
    in
    mapConfig fn config


{-| Use a multi select instead of a single select.
-}
withMultiSelection : Bool -> Config msg item -> Config msg item
withMultiSelection value config =
    config
        |> mapConfig
            (\c ->
                { c | isMultiSelect = value }
            )


{-| Text that will appear when no matches are found.

    config
        |> Select.withNotFound "No matches"

-}
withNotFound : String -> Config msg item -> Config msg item
withNotFound text config =
    let
        fn c =
            { c | notFound = text }
    in
    mapConfig fn config


{-| Set attributes for the not found message.

    config
        |> Select.withNotFoundAttrs [ class "red" ]

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


{-| Add attributes to the not found message.
This adds to existing attributes.

    config
        |> Select.withNotFoundMoreAttrs [ class "red" ]

-}
withNotFoundMoreAttrs :
    List (Attribute msg)
    -> Config msg item
    -> Config msg item
withNotFoundMoreAttrs attrs config =
    let
        fn c =
            { c | notFoundAttrs = c.notFoundAttrs ++ attrs }
    in
    mapConfig fn config


{-| Hide menu when no matches found.

    config
        |> Select.withNotFoundShown False

-}
withNotFoundShown : Bool -> Config msg item -> Config msg item
withNotFoundShown shown config =
    let
        fn c =
            { c | notFoundShown = shown }
    in
    mapConfig fn config


{-| Set attributes for the hightlighted item.

    config
        |> Select.withHighlightedItemAttrs [ class "red" ]

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


{-| Add attributes to the hightlighted item.

    config
        |> Select.withHighlightedItemMoreAttrs [ class "red" ]

-}
withHighlightedItemMoreAttrs :
    List (Attribute msg)
    -> Config msg item
    -> Config msg item
withHighlightedItemMoreAttrs attrs config =
    let
        fn c =
            { c | highlightedItemAttrs = c.highlightedItemAttrs ++ attrs }
    in
    mapConfig fn config


{-| Set attributes for the selected item in the menu.

    config
        |> Select.withItemSelectedAttrs [ class "selected" ]

-}
withItemSelectedAttrs :
    List (Attribute msg)
    -> Config msg item
    -> Config msg item
withItemSelectedAttrs attrs config =
    let
        fn c =
            { c | selectedItemAttrs = attrs }
    in
    mapConfig fn config


{-| Add attributes to the selected item in the menu.

    config
        |> Select.withItemSelectedMoreAttrs [ class "selected" ]

-}
withItemSelectedMoreAttrs :
    List (Attribute msg)
    -> Config msg item
    -> Config msg item
withItemSelectedMoreAttrs attrs config =
    let
        fn c =
            { c | selectedItemAttrs = c.selectedItemAttrs ++ attrs }
    in
    mapConfig fn config


{-| Add a callback for when the query changes.

    config
        |> Select.withOnQuery OnQuery

-}
withOnQuery : (String -> msg) -> Config msg item -> Config msg item
withOnQuery msg config =
    let
        fn c =
            { c | onQueryChange = Just msg }
    in
    mapConfig fn config


{-| Add a callback for when the input field receives focus.

    config
        |> Select.withOnFocus OnFocus

-}
withOnFocus : msg -> Config msg item -> Config msg item
withOnFocus msg config =
    let
        fn c =
            { c | onFocus = Just msg }
    in
    mapConfig fn config


{-| Add a callback for when the input field loses focus.

    config
        |> Select.withOnBlur OnBlur

-}
withOnBlur : msg -> Config msg item -> Config msg item
withOnBlur msg config =
    let
        fn c =
            { c | onBlur = Just msg }
    in
    mapConfig fn config


{-| Add a callback for when the Escape key is pressed.

    config
        |> Select.withOnEsc OnEsc

-}
withOnEsc : msg -> Config msg item -> Config msg item
withOnEsc msg config =
    let
        fn c =
            { c | onEsc = Just msg }
    in
    mapConfig fn config


{-| Set attributes for the prompt text (When no item is selected)

    config
        |> Select.withPromptAttrs [ class "prompt" ]

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


{-| Add attributes to the prompt text (When no item is selected)
This adds to existing attributes.

    config
        |> Select.withPromptMoreAttrs [ class "prompt" ]

-}
withPromptMoreAttrs :
    List (Attribute msg)
    -> Config msg item
    -> Config msg item
withPromptMoreAttrs attrs config =
    let
        fn c =
            { c | promptAttrs = c.promptAttrs ++ attrs }
    in
    mapConfig fn config


{-| Add a prompt text to be displayed when no element is selected.

    config
        |> Select.withPrompt "Select a movie"

-}
withPrompt : String -> Config msg item -> Config msg item
withPrompt prompt config =
    let
        fn c =
            { c | prompt = prompt }
    in
    mapConfig fn config


{-| Transform the input
This can be used to restrict input to certain characters.
Returning "" effectively disables input

    transform : String -> String
    transform input =
        ""

    config
    |> Select.withTransformInput transform

-}
withTransformInput : (String -> String) -> Config msg item -> Config msg item
withTransformInput transform config =
    let
        fn c =
            { c | transformInput = transform }
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

    config
    |> Select.withTransformQuery transform

-}
withTransformQuery : (String -> String) -> Config msg item -> Config msg item
withTransformQuery transform config =
    let
        fn c =
            { c | transformQuery = transform }
    in
    mapConfig fn config


{-| Specify a custom list of separators for the query
The default is `[ "\n", "\t", "," ]`

    config
        |> Select.withValueSeparators []

-}
withValueSeparators : List String -> Config msg item -> Config msg item
withValueSeparators valueSeparators config =
    let
        fn c =
            { c | valueSeparators = valueSeparators }
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
        selectState = Select.init "select1"
    }

-}
init : String -> State
init id =
    PrivateState (Models.newState id)


{-| Return the query string from the current state model

    Select.queryFromState model.selectState

-}
queryFromState : State -> Maybe String
queryFromState model =
    model
        |> unwrapModel
        |> .query


{-| Change the current query

    Select.withQuery (Just "hello") selectModel

-}
withQuery : Maybe String -> State -> State
withQuery query (PrivateState model) =
    PrivateState { model | query = query }


{-| Render the view

    Select.view
        selectConfig
        model.selectState
        availableItems
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
