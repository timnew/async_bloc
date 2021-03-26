# stated_result
[![Star this Repo](https://img.shields.io/github/stars/timnew/stated_result.svg?style=flat-square)](https://github.com/timnew/stated_result)
[![Pub Package](https://img.shields.io/pub/v/stated_result.svg?style=flat-square)](https://pub.dev/packages/stated_result)
[![Build Status](https://img.shields.io/github/workflow/status/timnew/stated_result/Run-Test)](https://github.com/timnew/stated_result/actions?query=workflow%3ARun-Test)

A library built upon [Bloc_Flutter] and [Provider] to make it easy to support async operation

This library includes 4 sub-modules:

## Multi-State Result

The library includes 4 different types of `MultiStateResult`, each has a different state to indicates its internal state. The type is an immutable data type, and can be pattern matched like enum.

* `ActionResult`: A result has 2 states: `Completed` and `Failed`. It can be used to represents the result of action without return value.
* `AsyncActionResult`: A result has 4 states: `Pending`, `Waiting`, `Completed`, and `Failed`. It represents the full lifecycle of an async action without a return value.
* `QueryResult<T>`: A result has 2 states: `Succeeded` and `Failed`, in which `Succeeded` would hold a value of given type `T`. It represents the result of a query that returns a certain type of data.
* `AsyncQueryResult<T>`: A result has 4, states: `Pending`, `Waiting`, `Suceeded`, and `Failed`. It represents a full lifecycle of a query that returns a certain type of data. Potentially, an extra state `Default` can be used. It is like `Pending` - indicates the query hasn't been started, but also holds a `value` like `Succeeded`. It can be used to indicate the scenario where the app provides default value as optimistic updates.

### How it works

Typically, the result can be used to represent the result of an async operation, such as calling API or loading data from DB, or time consuming data processing.

Typically, the result itself should be `AsyncActionResult` or `AsyncQueryResult`, depends on whether the app cares about the return value or not, and UI would render accordingly, such as `loading screen` `error screen` or the `successful screen`.

The query/action itself would be represented as `Future<QueryResult>`/`Future<ActionResult>`, which can be used to update `AsyncQueryResult` and `AsyncActionResult` accordingly.

Typically, `AsyncActionResult` would be held by a `Bloc` or `ValueNotifier`, which will be discussed below.

### Convert Sync Result to Async Result

`asAsyncResult` can convert sync result into its async counterpart accordingly.

```dart
AsyncActionResult asyncActionResult = actionResult.asAsyncResult();

AsyncQueryResult asyncQueryResult = queryResult.asAsyncResult();
```
### Convert Future Types

`Future.asActionResult` can materialise any future into `Future<ActionResult>`. The new future would always fulfill. If the original future fails, it captures the error into a `FailedResult` accordingly.

`Future<ActionResult>.asActionResult` would flatten the hierarchy and respect the failed value from the original future.

`Future<T>.asQueryResult` would materialise the future of `T` into `Future<QueryResult<T>>`. The new future would always fulfill. If original future fails it captures the error into a `FailedResult` accordingly.
## Multi-State Result Builder

`MultiStateResult` type provides `map` and/or `mapOr` method to pattern match and map the value, which can be used to build UI manually.

### `ActionResultBuilder` and `QueryResultBuilder`

In practice, `ActionResultBuilder` and `QueryResultBuilder` provided by this library can be more convenient, with few extra features.

`ActionResultBuilder` and `QueryResultBuilder` accept different builder function to build the UI according to the state of the `AsyncActionResult` or the `AsyncQueryResult`.

A simple example:

```dart

Widget build(BuildContext context, AsyncActionResult result) =>
  ActionResultBuilder(
      result: result,
      pendingBuilder: (_context) => Center(child: Text("No Data")),
      waitingBuilder:  (_context) => Center(child: CircularProgressIndicator()),
      failedBuilder: (_context, error, _stackTrace) => Center(
        child: Text("Error: $error"),
      ),
      completedBuilder: (_context) => Center(child: Text("Completed")),
  );
```
### Non critical state default builders

For `ActionResultBuilder` and `QueryResultBuilder`, `builder` is considered as a critical builder, which is mandatory each time the widget is instantiated, while `pendingBuilder`, `waitingBuilder`, and `failedBuilder` are optional and can be omitted.

When the given builder is omitted, the `ResultBuilder` will search the widget hierarchy to find any default builder that has been given. Just like `Text` would search `DefaultTextStyle` if `textStyle` is not explicitly given.

Accordingly, `DefaultPendingResultBuilder`, `DefaultWaitingResultBuilder`, and `DefaultFailedResultBuilder` can be used to provide those default builders to their children along the widget tree.

### DefaultResultBuilder

If more than one default builder needs to be configured, rather than nested `DefaultXXXResultBuilder`, which results in a relatively ugly code, `DefaultResultBuilder` can be used, which allow configuring multiple default builders at once.

`DefaultResultBuilder` can be used to set up the unified UI style of a portion of the screen.
### Global default builders

If optional builders are omitted and no default builders are given, the `ResultBuilder` widget would use something called `global default builder` to render the UI.

Which can be set up via

* `DefaultPendingResultBuilder.globalBuilder`
* `DefaultWaitingResultBuilder.globalBuilder`
* `DefaultFailedResultBuilder.globalBuilder`

It also can be configured in batch via `DefaultResultBuilder.setGlobalBuilder`

## Bloc Integration

Library provided the classes to integrate the [MultiStateResult] to Bloc

This library uses `Cubit` instead of `Bloc`, which is a simplified and easier-to-use `Bloc`.

* `ActionCubit`: A `Cubit` holds `AsyncActionResult`, it also provides protected methods to update its value from different kinds of `Future`
* `QueryCubit<T>`: A `Cubit` holds `AsyncQueryResult<T>`, it also provides protected methods to update its value from different kinds of `Future`

Both `ActionCubit` and `QueryCubit` can be provided to the widget tree via `BlocProvider`

### Bloc Builder and Bloc Consumer

Like `BlocBuilder` and `BlocConsumer` provided by [Bloc_Flutter] library, the following types are provided:

* `ActionBlocBuilder`: `BlocBuilder` that consumes `ActionCubit` via `ActionResultBuilder`
* `ActionBlocConsumer`: `BlocConsumer` that consumes `ActionCubit` via `ActionResultBuilder`
* `QueryBlocBuilder`: `BlocBuilder` that consumes `QueryCubit` via `QueryResultBuilder`
* `QueryBlocConsumer`: `BlocConsumer` that consumes `QueryCubit` via `QueryResultBuilder`

## ValueNotifier Integration

Besides `Cubit`, this library also provides the integration to `ValueNotifier` and `ListenableBuilder`.

* `ActionNotifier`: A `ValueNotifier` holds `AsyncActionResult`, it also provides protected methods to update its value from different kinds of `Future`
* `QueryNotifier<T>`: A `ValueNotifier` holds `AsyncQueryResult<T>`, it also provides protected methods to update its value from different kinds of `Future`

### Listenable Builder

Like `ListenableBuilder`, the following classes are provided:

* `ActionListenableBuilder`: `ListenableBuilder` that consumes `ActionNotifier` via `ActionResultBuilder`
* `QueryListenableBuilder`: `ListenableBuilder` that consumes `QueryNotifier` via `QueryResultBuilder`

## Deal with an empty list or nullable value

It could be kind of annoying to build a `ListView`/`GridView` from a `List`, which could be `empty`, or to build UI from a field of a JSON that could be `null`.
`EmptyableContentBuilder` is the widget designed to deal with those cases.

```dart
Widget build(BuildContext context) {
  return QueryBlocBuilder(
    bloc: context.read<MyStringListBloc>(),
    builder: (_, list) => EmptyableContentBuilder(
      value: list,
      emptyBuilder: (_) => Center(child: Text("List is empty")),
      builder: (_, list) => ListView.builder(
        itemCount: list.length,
        itemBuilder: (_, index) => ItemWidget(item: list[index]),
      ),
    );
  )
}
```

`EmptyableContentBuilder` supports empty checking for `List` `Map` `Iterable` and `String` by default, it treats `null` as empty too.
To make `BlankableBuilder` work with other types, `blankChecker` checker can be provided.


[Bloc_Flutter]:https://pub.dev/packages/flutter_bloc
[Provider]:https://pub.dev/packages/provider