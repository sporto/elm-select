module Select.Messages exposing (..)


type Msg item
    = NoOp
    | OnEsc
    | OnBlur
    | OnQueryChange String
    | OnSelect item
