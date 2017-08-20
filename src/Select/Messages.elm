module Select.Messages exposing (..)


type Msg item
    = NoOp
    | OnBlur
    | OnClear
    | OnEsc
    | OnDownArrow
    | OnUpArrow
    | OnQueryChange String
    | OnSelect item
