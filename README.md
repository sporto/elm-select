# Elm Select

[ ![Codeship Status for sporto/elm-select](https://app.codeship.com/projects/dbe35340-8a15-0135-1341-166aadcd1cb7/status?branch=master)](https://app.codeship.com/projects/248929)

An select component with autocomplete and optional multi-select.

## Demo

See https://sporto.github.io/elm-select/

## Example and Getting started

See commented example at [`demo/src/Example1Basic.elm`](demo/src/Example1Basic.elm)

## API

<http://package.elm-lang.org/packages/sporto/elm-select/latest>

### [Changelog](./CHANGELOG.md)

## Styling

You can style elements using:

- Using global classes e.g. `.elm-select-input`
- Pass classes via configuration e.g. `withInputClass`
- Passing styles via configuration e.g. `withInputStyles`

To add borders and padding to the input use `InputWrapper` instead of `Input`.

---

## Run demo locally

  make run-demo

Open `localhost:4000`

## Generate demo

  make build-demo

## Test

  make test
