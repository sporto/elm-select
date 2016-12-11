module Select.Messages exposing (..)


type Msg item
    = NoOp
    | OnQueryChange String
    | OnSelect item
