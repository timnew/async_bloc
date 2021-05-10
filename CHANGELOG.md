# Change Log

## [0.3.0-preview.1]

* Added `stated` library
  * Expose new `Stated` type as the base type
  * Moved results into `stated` library.
  * Added name suffix `State` to every states.
  * Renamed `Waiting` to `WorkingState`, `FailedState` to `ErrorState`, `SucceededState` to `DoneValueState`
  * Added `WorkingValueState` `ErrorValueState`
  * Renamed `ErrorWithStack` to `ErrorInfo`
  * Renamed `error` of `HasError` to `exception`, and changed type from `dynamic` to `Object`
  * Replaced `ValueResultMapper` `ErrorResultMapper` with `ValueMapper`
  * Renamed `ValueMapper` to `ValueTransformer`
  * Renamed `ResultMapper` to `StateTransformer`
  * Renamed `StatedResult.asFailed` to `StatedResult.asError`, and returns `ErrorInfo`
  * Renamed `StatedResult.asValueResult` to `StatedResult.asValue`, and returns value directly

* Change to `stated_result`
  * `QueryResult.succeeded` and `AsyncQueryResult.succeeded` are renamed to `completed`.
  * `AsyncQueryResult.mapValue` get dropped
  * `AsyncQueryResult.updateWith` and `AsyncActionResult.updateWith` method signature changed

* Change to `stated_result_builder`
  * Removed all the default builder
  * `ActionResultBuilder` and `QueryResultBuilder` becomes a wrapper of `StatedBuilder`

* Added `stated_builder` library
  * Added `StatedBuilder`
  * Added `WorkingIndicatorBuilder`

* Added `stated_value` library
  * Added `StatedValue`
  * Added `StatedValueCubit`

## [0.2.0] - 2021-05-04

* Upgraded dependencies
* Aligned generic parameter order of `QueryBlocBuilder` and `QueryBlocConsumer` to `BlocBuilder` and `BlocConsumer`
* `ActionBloc.captureResult` and `ActionResultNotifier.captureResult` returns original future.
* Added `AsyncQueryResult.fromValue` to create instance from value
* Added more tests

## [0.2.0-preview.5] - 2021-03-25

* Add `mapValue`
* Fix builder type issue for `EmptyableContentBuilder`
* Make BLoc builders and bloc consumers accept `BlocBase` instead of `Bloc`, so the `Cubit` can be applied
* Make `ActionBloc` and `QueryBloc` non-abstract
* Fix issue that `AsyncQueryResult.pending().updateWith` throws `AsyncQueryResult<T>` isn't subtype of `AsyncQueryResult<Never>`

## [0.2.0-preview.4] - 2021-03-23

* Rename `Busy` to `Waiting`
* Add documents for `stated_result_builder`
* Add tests for `stated_result_builder`
* Rename all result builders' default builder property from `valueBuilder` to `builder`
* Add new `.from` conversion factory method to convert `StatedResult` from one to another
* Add `updateWith` on `AsyncStatedResult`
* Add `captureResult` to `Cubit` and `ValueNotifier`
* Update `updateWith` parameter type on `Cubit` and `ValueNotifier`
* Remove `updateWithAsync` method
* Added `FutureResultBuilder` to consume future directly

## [0.2.0-preview.3] - 2021-03-20

* Refactor code
* Improve test coverage
* Improve document quality
* Improve naming
* Introduce `BlankableBuilder` to handle empty list or nullable value

## [0.2.0-preview.2] - 2021-03-19

* Try to export features into different libraries

## [0.2.0-preview.1] - 2021-03-19

* Reshape Project and rename project from `async_bloc` to `stated_result`

## [0.1.1] - 2021-03-18

* Added `ValueNotifier` and `ListenableBuilder` integration

## [0.1.0] - 2021-03-18

* First release
