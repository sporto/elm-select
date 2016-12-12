module Select.Messages exposing (..)


type Msg item
    = NoOp
    | OnEsc
    | OnInputBlur
    | OnQueryChange String
    | OnSelect item
