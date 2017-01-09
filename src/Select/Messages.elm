module Select.Messages exposing (..)


type Msg item
    = NoOp
    | OnBlur
    | OnClear
    | OnEsc
    | OnQueryChange String
    | OnSelect item
