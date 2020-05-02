module Select exposing
    ( RequiredConfig, Config, State, Msg
    , newConfig, withCustomInput, withCutoff, withOnQuery, withEmptySearch, withTransformQuery
    , withMultiSelection, withOnRemoveItem, withMultiInputItemContainerClass, withMultiInputItemContainerStyles, withMultiInputItemClass, withMultiInputItemStyles
    , withInputControlClass, withInputControlStyles
    , withInputWrapperClass, withInputWrapperStyles
    , withInputId, withInputClass, withInputStyles, withOnFocus
    , withClear, withClearClass, withClearStyles, withClearSvgClass
    , withUnderlineClass, withUnderlineStyles
    , withItemClass, withItemStyles, withItemHtml, withHighlightedItemClass, withHighlightedItemStyles
    , withMenuClass, withMenuStyles
    , withNotFound, withNotFoundClass, withNotFoundShown, withNotFoundStyles
    , withPrompt, withPromptClass, withPromptStyles
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

@docs withMultiSelection, withOnRemoveItem, withMultiInputItemContainerClass, withMultiInputItemContainerStyles, withMultiInputItemClass, withMultiInputItemStyles


# Configure the input control

This is the container that wraps the entire select view

@docs withInputControlClass, withInputControlStyles


# Configure the input wapper

This is the element that wraps the selected item(s) and the input

@docs withInputWrapperClass, withInputWrapperStyles


# Configure the input

@docs withInputId, withInputClass, withInputStyles, withOnFocus


# Configure the clear button

@docs withClear, withClearClass, withClearStyles, withClearSvgClass


# Configure an underline element under the input

@docs withUnderlineClass, withUnderlineStyles


# Configure the items

@docs withItemClass, withItemStyles, withItemHtml, withHighlightedItemClass, withHighlightedItemStyles


# Configure the menu

@docs withMenuClass, withMenuStyles


# Configure the not found message

@docs withNotFound, withNotFoundClass, withNotFoundShown, withNotFoundStyles


# Configure the prompt

@docs withPrompt, withPromptClass, withPromptStyles


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
    { onSelect : Maybe item -> msg
    , toLabel : item -> String
    , filter : String -> List item -> Maybe (List item)
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
    Config.newConfig requiredConfig
        |> PrivateConfig


{-| Show results if the input is focused, but the query is empty
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


{-| Add classes to the input control

    Select.withInputControlClass "control-class" config

-}
withInputControlClass : String -> Config msg item -> Config msg item
withInputControlClass classes config =
    let
        fn c =
            { c | inputControlClass = classes }
    in
    mapConfig fn config


{-| Add styles to the input control

    Select.withInputControlClass [ ( "background-color", "red" ) ] config

-}
withInputControlStyles : List ( String, String ) -> Config msg item -> Config msg item
withInputControlStyles styles config =
    let
        fn c =
            { c | inputControlStyles = styles }
    in
    mapConfig fn config


{-| Add classes to the underline div

    Select.withUnderlineClass "underline" config

-}
withUnderlineClass : String -> Config msg item -> Config msg item
withUnderlineClass classes config =
    let
        fn c =
            { c | underlineClass = classes }
    in
    mapConfig fn config


{-| Add styles to the underline div

    Select.withUnderlineStyles [ ( "width", "2rem" ) ] config

-}
withUnderlineStyles : List ( String, String ) -> Config msg item -> Config msg item
withUnderlineStyles styles config =
    let
        fn c =
            { c | underlineStyles = styles }
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


{-| Add classes to the clear button

    Select.withClearClass "clear" config

-}
withClearClass : String -> Config msg item -> Config msg item
withClearClass classes config =
    let
        fn c =
            { c | clearClass = classes }
    in
    mapConfig fn config


{-| Add styles to the clear button

    Select.withClearStyles [ ( "width", "2rem" ) ] config

-}
withClearStyles : List ( String, String ) -> Config msg item -> Config msg item
withClearStyles styles config =
    let
        fn c =
            { c | clearStyles = styles }
    in
    mapConfig fn config


{-| Add classes to the clear SVG icon

    Select.withClearSvgClass "clear" config

-}
withClearSvgClass : String -> Config msg item -> Config msg item
withClearSvgClass classes config =
    let
        fn c =
            { c | clearSvgClass = classes }
    in
    mapConfig fn config


{-| Enable user to add custom values

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


{-| Set the ID of the input

    Select.withInputId "input-id" config

-}
withInputId : String -> Config msg item -> Config msg item
withInputId id config =
    let
        fn c =
            { c | inputId = id }
    in
    mapConfig fn config


{-| Add classes to the input

    Select.withInputClass "col-12" config

-}
withInputClass : String -> Config msg item -> Config msg item
withInputClass classes config =
    let
        fn c =
            { c | inputClass = classes }
    in
    mapConfig fn config


{-| Add styles to the input

    Select.withInputStyles [ ( "color", "red" ) ] config

-}
withInputStyles : List ( String, String ) -> Config msg item -> Config msg item
withInputStyles styles config =
    let
        fn c =
            { c | inputStyles = styles }
    in
    mapConfig fn config


{-| Add classes to the input wrapper (element that wraps the input and the clear button)

    Select.withInputWrapperClass "col-12" config

-}
withInputWrapperClass : String -> Config msg item -> Config msg item
withInputWrapperClass classes config =
    let
        fn c =
            { c | inputWrapperClass = classes }
    in
    mapConfig fn config


{-| Add styles to the input wrapper

    Select.withInputWrapperStyles [ ( "color", "red" ) ] config

-}
withInputWrapperStyles : List ( String, String ) -> Config msg item -> Config msg item
withInputWrapperStyles styles config =
    let
        fn c =
            { c | inputWrapperStyles = styles }
    in
    mapConfig fn config


{-| Add classes to the items

    Select.withItemClass "border-bottom" config

-}
withItemClass : String -> Config msg item -> Config msg item
withItemClass classes config =
    let
        fn c =
            { c | itemClass = classes }
    in
    mapConfig fn config


{-| Add styles to the items

    Select.withItemStyles [ ( "color", "peru" ) ] config

-}
withItemStyles : List ( String, String ) -> Config msg item -> Config msg item
withItemStyles styles config =
    let
        fn c =
            { c | itemStyles = styles }
    in
    mapConfig fn config


{-| Custom item element HTML

    Select.withItemHtml (\i -> Html.li [] [ text i ]) config

When this is used the original `toLabel` function in the config is ignored.

-}
withItemHtml : (item -> Html Never) -> Config msg item -> Config msg item
withItemHtml html config =
    let
        fn c =
            { c | itemHtml = Just html }
    in
    mapConfig fn config


{-| Add classes to the menu

    Select.withMenuClass "bg-white" config

-}
withMenuClass : String -> Config msg item -> Config msg item
withMenuClass classes config =
    let
        fn c =
            { c | menuClass = classes }
    in
    mapConfig fn config


{-| Add styles to the menu

    Select.withMenuStyles [ ( "padding", "1rem" ) ] config

-}
withMenuStyles : List ( String, String ) -> Config msg item -> Config msg item
withMenuStyles styles config =
    let
        fn c =
            { c | menuStyles = styles }
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


{-| Add classes to the container of selected items

    Select.withMultiInputItemContainerClass "bg-white" config

-}
withMultiInputItemContainerClass : String -> Config msg item -> Config msg item
withMultiInputItemContainerClass classes config =
    let
        fn c =
            { c | multiInputItemContainerClass = classes }
    in
    mapConfig fn config


{-| Add styles to the container of selected items

    Select.withMultiInputClass "bg-white" config

-}
withMultiInputItemContainerStyles : List ( String, String ) -> Config msg item -> Config msg item
withMultiInputItemContainerStyles styles config =
    let
        fn c =
            { c | multiInputItemContainerStyles = styles }
    in
    mapConfig fn config


{-| Add classes to an individual selected item

    Select.withMultiInputItemClass "bg-white" config

-}
withMultiInputItemClass : String -> Config msg item -> Config msg item
withMultiInputItemClass classes config =
    let
        fn c =
            { c | multiInputItemClass = classes }
    in
    mapConfig fn config


{-| Add styles to an individual selected item

    Select.withMultiInputItemStyles [ ( "padding", "1rem" ) ] config

-}
withMultiInputItemStyles : List ( String, String ) -> Config msg item -> Config msg item
withMultiInputItemStyles styles config =
    let
        fn c =
            { c | multiInputItemStyles = styles }
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


{-| Class for the not found message

    Select.withNotFoundClass "red" config

-}
withNotFoundClass : String -> Config msg item -> Config msg item
withNotFoundClass class config =
    let
        fn c =
            { c | notFoundClass = class }
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


{-| Styles for the not found message

    Select.withNotFoundStyles [ ( "padding", "1rem" ) ] config

-}
withNotFoundStyles : List ( String, String ) -> Config msg item -> Config msg item
withNotFoundStyles styles config =
    let
        fn c =
            { c | notFoundStyles = styles }
    in
    mapConfig fn config


{-| Class for the hightlighted tem

    Select.withHighlightedItemClass "red" config

-}
withHighlightedItemClass : String -> Config msg item -> Config msg item
withHighlightedItemClass class config =
    let
        fn c =
            { c | highlightedItemClass = class }
    in
    mapConfig fn config


{-| Styles for the highlighted item

    Select.withHighlightedItemStyles [ ( "padding", "1rem" ) ] config

-}
withHighlightedItemStyles : List ( String, String ) -> Config msg item -> Config msg item
withHighlightedItemStyles styles config =
    let
        fn c =
            { c | highlightedItemStyles = styles }
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


{-| Add classes to the prompt text (When no item is selected)
Select.withPromptClass "prompt" config
-}
withPromptClass : String -> Config msg item -> Config msg item
withPromptClass classes config =
    let
        fn c =
            { c | promptClass = classes }
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


{-| Add styles to prompt text

    Select.withPromptStyles [ ( "color", "red" ) ] config

-}
withPromptStyles : List ( String, String ) -> Config msg item -> Config msg item
withPromptStyles styles config =
    let
        fn c =
            { c | promptStyles = styles }
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
    -> Html (Msg item)
view config model items selected =
    Select.Select.view
        (unwrapConfig config)
        (unwrapModel model)
        items
        selected
        |> Html.map PrivateMsg


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
