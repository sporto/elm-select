module Select.Messages exposing (..)


type Msg item
    = NoOp
    | OnFocus
    | OnBlur
    | OnClear
    | OnEsc
    | OnDownArrow
    | OnUpArrow
    | OnQueryChange String
    | OnSelect item
