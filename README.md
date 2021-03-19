# Elm Select

[ ![Codeship Status for sporto/elm-select](https://app.codeship.com/projects/dbe35340-8a15-0135-1341-166aadcd1cb7/status?branch=master)](https://app.codeship.com/projects/248929)

An select component with autocomplete and optional multi-select.

## Demo

See https://sporto.github.io/elm-select/

## Example and Getting started

See commented example at [`demo/src/Example.elm`](demo/src/Example.elm)

## API

<http://package.elm-lang.org/packages/sporto/elm-select/latest>

### [Changelog](./CHANGELOG.md)

## Styling

Copy the CSS from [here](https://github.com/sporto/elm-select/blob/master/src/styles.css).

You can also style elements by passing attributes in the configuration:

```
config
|> withInputWrapperAttrs`[ style "background" "salmon" ]
```

To add borders and padding to the input use `InputWrapper` instead of `Input`.

---

## Run demo locally

  make run-demo

Open `localhost:4000`

## Generate demo

  make build-demo

## Test

  make test
