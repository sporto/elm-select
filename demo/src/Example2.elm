module Example2 exposing (..)

import Debug
import Html exposing (..)
import Html.Attributes exposing (class)
import Http
import Json.Decode as Decode
import Select


type alias Model =
    { id : String
    , characters : List Character
    , selectedCharacterId : Maybe String
    , selectState : Select.State
    }


type alias Character =
    String


initialModel : String -> Model
initialModel id =
    { id = id
    , characters = []
    , selectedCharacterId = Nothing
    , selectState = Select.newState id
    }


initialCmds : Cmd Msg
initialCmds =
    Cmd.none


type Msg
    = NoOp
    | OnSelect (Maybe Character)
    | SelectMsg (Select.Msg Character)
    | OnFetch (Result Http.Error (List Character))
    | OnQuery String


itemHtml : Character -> Html Never
itemHtml c =
    Html.div []
        [ Html.i [ class "fa fa-rebel" ] []
        , text (" " ++ c)
        ]


selectConfig : Select.Config Msg Character
selectConfig =
    Select.newConfig OnSelect identity
        |> Select.withInputWrapperStyles
            [ ( "padding", "0.4rem" ) ]
        |> Select.withMenuClass "border border-gray bg-white"
        |> Select.withItemClass "border-bottom border-silver p1"
        |> Select.withItemStyles [ ( "font-size", "1rem" ) ]
        |> Select.withNotFoundShown False
        |> Select.withHighlightedItemClass "bg-silver"
        |> Select.withHighlightedItemStyles [ ( "color", "black" ) ]
        |> Select.withPrompt "Select a character"
        |> Select.withCutoff 12
        |> Select.withOnQuery OnQuery
        |> Select.withItemHtml itemHtml
        |> Select.withUnderlineClass "underline"
        |> Select.withEmptySearch False
        |> Select.withTransformQuery
            (\query ->
                if String.length query < 3 then
                    Nothing
                else
                    Just query
            )


fetchUrl : String -> String
fetchUrl query =
    "https://swapi.co/api/people/?search=" ++ query


fetch : String -> Cmd Msg
fetch query =
    Http.get (fetchUrl query) resultDecoder
        |> Http.send OnFetch


resultDecoder : Decode.Decoder (List Character)
resultDecoder =
    Decode.at [ "results" ] collectionDecoder


collectionDecoder : Decode.Decoder (List Character)
collectionDecoder =
    Decode.list memberDecoder


memberDecoder : Decode.Decoder Character
memberDecoder =
    Decode.field "name" Decode.string


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "msg" msg of
        OnQuery query ->
            ( model, fetch query )

        OnFetch result ->
            case result of
                Ok characters ->
                    ( { model | characters = characters }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        OnSelect maybeCharacterId ->
            ( { model | selectedCharacterId = maybeCharacterId }, Cmd.none )

        SelectMsg subMsg ->
            let
                ( updated, cmd ) =
                    Select.update selectConfig subMsg model.selectState
            in
            ( { model | selectState = updated }, cmd )

        NoOp ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    let
        selecteCharacter =
            case model.selectedCharacterId of
                Nothing ->
                    Nothing

                Just id ->
                    model.characters
                        |> List.filter (\character -> character == id)
                        |> List.head
    in
    div [ class "bg-silver p1" ]
        [ h3 [] [ text "Async example" ]
        , text (toString model.selectedCharacterId)
        , h4 [] [ text "Pick an star wars character" ]
        , Html.map SelectMsg (Select.view selectConfig model.selectState model.characters selecteCharacter)
        ]
