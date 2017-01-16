module Select
    exposing
        ( Config
        , State
        , Msg
        , newConfig
        , newState
        , update
        , view
        , withClearClass
        , withClearStyles
        , withClearSvgClass
        , withCutoff
        , withInputClass
        , withInputStyles
        , withInputWrapperClass
        , withInputWrapperStyles
        , withItemClass
        , withItemStyles
        , withMenuClass
        , withMenuStyles
        , withOnQuery
        , withPrompt
        , withPromptClass
        , withPromptStyles
        )

{-| Select input with auto-complete

# Types
@docs Config, State, Msg

# Configuration
@docs newConfig, withCutoff, withOnQuery

# Styling

@docs withClearClass, withClearStyles, withClearSvgClass, withInputClass, withInputStyles, withInputWrapperClass, withInputWrapperStyles, withMenuClass, withMenuStyles, withItemClass, withItemStyles

# State
@docs newState

# view
@docs view

# Update
@docs update
-}

import Html exposing (..)
import Select.Select
import Select.Models as Models
import Select.Messages as Messages
import Select.Update


{-|
Opaque type that holds the configuration
-}
type Config msg item
    = PrivateConfig (Models.Config msg item)


{-|
Opaque type that holds the current state
-}
type State
    = PrivateState Models.State


{-|
Opaque type for internal library messages
-}
type Msg item
    = PrivateMsg (Messages.Msg item)


{-|
Create a new configuration. This takes:

- A message to trigger when an item is selected
- A function to get a label to display from an item


    Select.newConfig OnSelect .label
-}
newConfig : (Maybe item -> msg) -> (item -> String) -> Config msg item
newConfig onSelectMessage toLabel =
    PrivateConfig (Models.newConfig onSelectMessage toLabel)


{-|
Add classes to the clear button

    Select.withClearClass "clear" config
-}
withClearClass : String -> Config msg item -> Config msg item
withClearClass classes config =
    let
        fn c =
            { c | clearClass = classes }
    in
        fmapConfig fn config


{-|
Add styles to the clear button

    Select.withClearStyles [("width", "2rem")] config
-}
withClearStyles : List ( String, String ) -> Config msg item -> Config msg item
withClearStyles styles config =
    let
        fn c =
            { c | clearStyles = styles }
    in
        fmapConfig fn config


{-|
Add classes to the clear SVG icon

    Select.withClearSvgClass "clear" config
-}
withClearSvgClass : String -> Config msg item -> Config msg item
withClearSvgClass classes config =
    let
        fn c =
            { c | clearSvgClass = classes }
    in
        fmapConfig fn config


{-|
Add classes to the input

    Select.withInputClass "col-12" config
-}
withInputClass : String -> Config msg item -> Config msg item
withInputClass classes config =
    let
        fn c =
            { c | inputClass = classes }
    in
        fmapConfig fn config


{-|
Add styles to the input

    Select.withInputStyles [("color", "red")] config
-}
withInputStyles : List ( String, String ) -> Config msg item -> Config msg item
withInputStyles styles config =
    let
        fn c =
            { c | inputStyles = styles }
    in
        fmapConfig fn config


{-|
Add classes to the input wrapper (element that wraps the input and the clear button)

    Select.withInputWrapperClass "col-12" config
-}
withInputWrapperClass : String -> Config msg item -> Config msg item
withInputWrapperClass classes config =
    let
        fn c =
            { c | inputWrapperClass = classes }
    in
        fmapConfig fn config


{-|
Add styles to the input wrapper

    Select.withInputWrapperStyles [("color", "red")] config
-}
withInputWrapperStyles : List ( String, String ) -> Config msg item -> Config msg item
withInputWrapperStyles styles config =
    let
        fn c =
            { c | inputWrapperStyles = styles }
    in
        fmapConfig fn config


{-|
Add classes to the menu

    Select.withMenuClass "bg-white" config
-}
withMenuClass : String -> Config msg item -> Config msg item
withMenuClass classes config =
    let
        fn c =
            { c | menuClass = classes }
    in
        fmapConfig fn config


{-|
Add styles to the menu

    Select.withMenuStyles [("padding", "1rem")] config
-}
withMenuStyles : List ( String, String ) -> Config msg item -> Config msg item
withMenuStyles styles config =
    let
        fn c =
            { c | menuStyles = styles }
    in
        fmapConfig fn config


{-|
Add classes to the items

    Select.withItemClass "border-bottom" config
-}  
withItemClass : String -> Config msg item -> Config msg item
withItemClass classes config =
    let
        fn c =
            { c | itemClass = classes }
    in
        fmapConfig fn config


{-|
Add styles to the items

    Select.withItemStyles [("color", "peru")] config
-}
withItemStyles : List ( String, String ) -> Config msg item -> Config msg item
withItemStyles styles config =
    let
        fn c =
            { c | itemStyles = styles }
    in
        fmapConfig fn config


{-|
Set the maxium number of items to show

    Select.withCutoff 6 config
-}
withCutoff : Int -> Config msg item -> Config msg item
withCutoff n config =
    let
        fn c =
            { c | cutoff = Just n }
    in
        fmapConfig fn config


{-|
Add a callback for when the query changes

    Select.withOnQuery OnQuery
-}
withOnQuery : (String -> msg) -> Config msg item -> Config msg item
withOnQuery msg config =
    let
        fn c =
            { c | onQueryChange = Just msg }
    in
        fmapConfig fn config


{-|
Add classes to the prompt text (When no item is selected)
    Dropdown.withPromptClass "prompt" config
-}
withPromptClass : String -> Config msg item -> Config msg item
withPromptClass classes config =
    let
        fn c =
            { c | promptClass = classes }
    in
        fmapConfig fn config


{-|
Add a prompt text to be displayed when no element is selected
    Dropdown.withPrompt "Select a movie" config
-}
withPrompt : String -> Config msg item -> Config msg item
withPrompt prompt config =
    let
        fn c =
            { c | prompt = prompt }
    in
        fmapConfig fn config


{-|
Add styles to prompt text
    Dropdown.withPromptStyles [("color", "red")] config
-}
withPromptStyles : List ( String, String ) -> Config msg item -> Config msg item
withPromptStyles styles config =
    let
        fn c =
            { c | promptStyles = styles }
    in
        fmapConfig fn config


{-|
@priv
-}
fmapConfig : (Models.Config msg item -> Models.Config msg item) -> Config msg item -> Config msg item
fmapConfig fn config =
    let
        config_ =
            unwrapConfig config
    in
        PrivateConfig (fn config_)


{-|
Create a new state. You must pass a unique identifier for each select component.

    {
        ...
        selectState = Select.newState "select1"
    }
-}
newState : String -> State
newState id =
    PrivateState (Models.newState id)


{-|
Render the view

    Html.map SelectMsg (Select.view selectConfig model.selectState model.items selectedItem)
-}
view : Config msg item -> State -> List item -> Maybe item -> Html (Msg item)
view config model items selected =
    let
        config_ =
            unwrapConfig config

        model_ =
            unwrapModel model
    in
        Html.map PrivateMsg (Select.Select.view config_ model_ items selected)


{-|
Update the component state

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


{-|
@priv
-}
unwrapConfig : Config msg item -> Models.Config msg item
unwrapConfig config =
    case config of
        PrivateConfig c ->
            c


{-|
@priv
-}
unwrapMsg : Msg item -> Messages.Msg item
unwrapMsg msg =
    case msg of
        PrivateMsg m ->
            m


{-|
@priv
-}
unwrapModel : State -> Models.State
unwrapModel model =
    case model of
        PrivateState m ->
            m
