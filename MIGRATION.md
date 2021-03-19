# Migration

## From 3 to 4

### `toMsg`

You need to pass a `toMsg` attribute that tells the component how to map messages back to its update function. e.g.

```
type Msg =
  SelectMsg Select.Msg

toMsg = SelectMsg
```

### Styles and classes

All configuration for styles and classes has been removed in favour plain CSS.
Please copy the default CSS from `src/styles.css`.

You can also pass classes and styles via attributes:

Before:

```
|> withInputClass "col-2"
```

Now:

```
|> withInputAttrs [ class "col-2" ]
```