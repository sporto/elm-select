module Color exposing (Color(..), colors, toLabel)


type Color
    = Red
    | Yellow
    | Blue
    | Orange
    | Green
    | Purple
    | White
    | Black
    | Grey


colors : List Color
colors =
    [ Red
    , Yellow
    , Blue
    , Orange
    , Green
    , Purple
    , White
    , Black
    , Grey
    ]


toLabel : Color -> String
toLabel c =
    case c of
        Red ->
            "Red"

        Yellow ->
            "Yellow"

        Blue ->
            "Blue"

        Orange ->
            "Orange"

        Green ->
            "Green"

        Purple ->
            "Purple"

        White ->
            "White"

        Black ->
            "Black"

        Grey ->
            "Grey"
