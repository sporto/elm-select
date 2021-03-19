# Changelog

## 4.0.0

- All configuration for styles and classes has been changed to Attrs e.g. Replaced `withInputClass` and `withInputStyles` for `withInputAttrs`
- All default styles has been removed (Use provided CSS instead)

## 3.2.0

- Added `withCustomInput`

## 3.1.3

- Selecting an element in the list with Enter doesn't trigger a submit event on a form. See https://github.com/sporto/elm-select/issues/42

## 3.1.2

- Fix https://github.com/sporto/elm-select/issues/40

## 3.1.1

- Add Placeholder to multi-select

## 3.1.0

- Added `withClear`

## 3.0.0

Until this package has been using `tripokey/elm-fuzzy` for filtering results. Although this is a powerful package, it is quite finicky and difficult to configure. It is also a heavy dependecy. In many cases you can filter items with something simpler like `String.contains` or an alternative package. This version removes `elm-fuzzy` completly in favour of the host application providing its own search.

### Removed:

- This version removes the build in fuzzy search. You need to filter items yourself using `config.filter`.
- Remove all `fuzz...` config options.

### Changed:

- `newConfig` now takes a `RequiredConfig` record as first argument.

### Added:

- Config takes a `filter` function. This function should filter the items according to the query.

## 2.17.0

- Add `queryFromState`. See https://github.com/sporto/elm-select/pull/32

## 2.16.0

- Upgrade to Elm 0.19
- Add multi selection

## 2.15.1

- The `withOnQuery` callback takes in account `withTransformQuery`

## 2.15

- Add `withEmptySearch`

## 2.14

- Add `withFuzzyMatching`

## 2.13

- Add `withItemHtml`

## 2.12.1

- Change the default `fuzzySearchSeparators` to `[" "]`. This makes the default search more intuitive.

## 2.12.0

- Add `OnFocus`
- Allow to select item using Enter when there is only one item in search results

## 2.11.0

- Add `withInputId`

## 2.10.0

- Add arrow navigation

## 2.9.0

- Add `withFuzzySearchInsertPenalty`

## 2.8.0

- Add `withTransformQuery`

## 2.7.0

- Add `withNotFoundHidden`

## 2.6.0

- Add `withUnderlineClass`, `withUnderlineStyles`

## 2.5.1

- Fix issue with on blur in IE and Firefox

## 2.5.0

- Add:
  - `withFuzzySearchAddPenalty`
  - `withFuzzySearchMovePenalty`
  - `withFuzzySearchRemovePenalty`
  - `withFuzzySearchSeparators`

## 2.4.0

- Add `withScoreThreshold`

## 2.3.0

- Add not found message
- Add not found styles

## 2.2.0

- Add withPrompt
- Hide clear icon when nothing is selected
- Hide the menu when the query is empty

## 2.1.0

- Add `withClearStyles`, `withClearSvgClass`, `withInputWrapperClass`, `withInputWrapperStyles`

## 2.0.0

- Update a clear button, change selection type to `Maybe item`

## 1.2.0

- Add `withOnQuery` for async lookup

## 1.1.0

- Add Styles mutators e.g. `withItemStyles`

## 1.0.0

- Initial release
