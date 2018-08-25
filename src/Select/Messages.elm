module Select.Messages exposing (Msg(..))


type Msg item
    = NoOp
    | OnFocus
    | OnBlur
    | OnClear
    | OnRemoveItem item
    | OnEsc
    | OnDownArrow
    | OnUpArrow
    | OnQueryChange String
    | OnSelect item
