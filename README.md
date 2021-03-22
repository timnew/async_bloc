# stated_result
[![Star this Repo](https://img.shields.io/github/stars/timnew/stated_result.svg?style=flat-square)](https://github.com/timnew/stated_result)
[![Pub Package](https://img.shields.io/pub/v/stated_result.svg?style=flat-square)](https://pub.dev/packages/stated_result)
[![Build Status](https://img.shields.io/github/workflow/status/timnew/stated_result/Run-Test)](https://github.com/timnew/stated_result/actions?query=workflow%3ARun-Test)

A library built upon [Bloc_Flutter] and [Provider] to make it easy to support async operation

This library includes 4 sub-modules:

## Multi-State Result

The library includes 4 different types of `MultiStateResult`, each has different state to indicates its internal state. The type is immutable data type, and can be pattern matched like enum.

* `ActionResult`: A result has 2 states: `Completed` and `Failed`. It can be used to represents the result of an action without return value.
* `AsyncActionResult`: A result has 4 states: `Pending`, `Busy`, `Completed`, and `Failed`. It represents the full lifecycle of an async action without a return value.
* `QueryResult<T>`: A result has 2 states: `Succeeded` and `Failed`, in which `Succeeded` would holds a value of given type `T`. It represents the result of a query that returns a certain type of data.
* `AsyncQueryResult<T>`: A result has 4, states: `Pending`, `Busy`, `Suceeded`, and `Failed`. It represents a full lifecycle of a query that returns a certain type of data. Potentially, an extra state `Default` can be used, it is like `Pending` indicates the query hasn't been started yet, but also holds a `value` like `Succeeded`. It can be used to indicates the scenario which app provides default value as optimistic updates.

### How it works

Typically, the result can be used to represent the result of an async operation, such as calling API or loading data from DB, or time consuming data processing.

Typically, the result itself should be `AsyncActionResult` or `AsyncQueryResult`, depends on whether app cares about the return value or not, and UI would renders accordingly, such as `loading screen` `error screen` or the `successful screen`.

The query/action itself, would be represented as `Future<QueryResult>`/`Future<ActionResult>`, which can be used to update `AsyncQueryResult` and `AsyncActionResult` accordingly.

Typically, `AsyncActionResult` would be holds by a `Bloc` or `ValueNotifier`, which will be discussed below.

### Convert Sync Result to Async Result

`asAsyncResult` can convert sync result into its async counterpart accordingly.

```dart
AsyncActionResult asyncActionResult = actionResult.asAsyncResult();

AsyncQueryResult asyncQueryResult = queryResult.asAsyncResult();
```
### Convert Future Types

`Future.asActionResult` can materialise any future into `Future<ActionResult>` . The new future would always fulfills, when original future failed, it captures the error into a `FailedResult` accordingly.

`Future<ActionResult>.asActionResult`  would flatten the hierarchy and respect the failed value from original future.

`Future<T>.asQueryResult` would matertialse the future of `T` into `Future<QueryResult<T>>`. The new future would always fulfills, when original future failed, it captures the error into a `FailedResult` accordingly.
## Multi-State Result Builder

`MultiStateResult` types provide `map` and/or `mapOr` method to pattern match and map the value, which can be used to build UI manually.

### `ActionResultBuilder` and `QueryResultBuilder`

In practise, `ActionResultBuilder` and `QueryResultBuilder` provided by this library can be more convenient, with a few extra features.

`ActionResultBuilder` and `QueryResultBuilder` accepts different builder function to build the UI according to the state of the `AsyncActionResult` or the `AsyncQueryResult`.

An simple example:

```dart

Widget build(BuildContext context, AsyncActionResult result) =>
  ActionResultBuilder(
      result: result,
      pendingBuilder: (_context) => Center(child: Text("No Data")),
      busyBuilder:  (_context) => Center(child: CircularProgressIndicator()),
      failedBuilder: (_context, error, _stackTrace) => Center(
        child: Text("Error: $error"),
      ),
      completedBuilder: (_context) => Center(child: Text("Completed")),
  );
```
### Non critical state default builders

For `ActionResultBuilder` and `QueryResultBuilder`, `completed` and `succeeded` are considered as critical builder, which is mandatory each time to instantiate the Widget. While `pendingBuilder`, `busyBuilder`, and `failedBuilder` are optional, which can be omitted.

When the given builder is omitted, the `ResultBuilder` would search the widget hierarchy to find any default builder has been given. Just like `Text` would search `DefaultTextStyle` if `textStyle` is not explicitly given.

Accordingly, `DefaultPendingResultBuilder`, `DefaultBusyResultBuilder`, and `DefaultFailedResultBuilder` can be used to provide those default builders to their children along the widget tree.

### DefaultResultBuilder

If more than one default builder needs to be configured, rather than nested `DefaultXXXResultBuilder`, which results a relatively ugly code, `DefaultResultBuilder` can be used, which allow to configure multiple default builders at once.

`DefaultResultBuilder` can be use to setup the unified UI style of a portion of the screen.
### Global default builders

If optional builders are omitted, and no default builder are given. The `ResultBuilder` widget would uses something called `global default builder` to render the UI.

Which can be setup via

* `DefaultPendingResultBuilder.globalBuilder`
* `DefaultBusyResultBuilder.globalBuilder`
* `DefaultFailedResultBuilder.globalBuilder`

It also can be configured in batch via `DefaultResultBuilder.setGlobalBuilder`

## Bloc Integration

Library provided the classes to integrate the [MultiStateResult] to Bloc

This library uses `Cubit` instead of `Bloc`, which is a simplified and easier-to-use `Bloc`.

* `ActionCubit`: A `Cubit` holds `AsyncActionResult`, it also provides protected methods to update its value from different kinds of `Future`
* `QueryCubit<T>`: A `Cubit` holds `AsyncQueryResult<T>`, it also provides protected methods to update its value from different kinds of `Future`

Both `ActionCubit` and `QueryCubit` can be provided into widget tree via `BlocProvider`

### Bloc Builder and Bloc Consumer

Like `BlocBuilder` and `BlocConsumer` provided by [Bloc_Flutter] library, the following types are provided:

* `ActionBlocBuilder`: `BlocBuilder` that consumes `ActionCubit` via `ActionResultBuilder`
* `ActionBlocConsumer`: `BlocConsumer` that consumes `ActionCubit` via `ActionResultBuilder`
* `QueryBlocBuilder`: `BlocBuilder` that consumes `QueryCubit` via `QueryResultBuilder`
* `QueryBlocConsumer`: `BlocConsumer` that consumes `QueryCubit` via `QueryResultBuilder`

## ValueNotifier Integration

Besides of Bloc, this library also provides the integration to `ValueNotifier` and `ListenableBuilder`.

* `ActionNotifier`: A `ValueNotifier` holds `AsyncActionResult`, it also provides protected methods to update its value from different kinds of `Future`
* `QueryNotifier<T>`: A `ValueNotifier` holds `AsyncQueryResult<T>`, it also provides protected methods to update its value from different kinds of `Future`

### Listenable Builder

Like `ListenableBuilder, the following classes are provided:

* `ActionListenableBuilder`: `ListenableBuilder` that consumes `ActionNotifier` via `ActionResultBuilder`
* `QueryListenableBuilder`: `ListenableBuilder` that consumes `QueryNotifier` via `QueryResultBuilder`

## Deal with empty list or nullable value

It could be kind of annoying to build a `ListView`/`GridView` from a `List`, which could be `empty`, or to build UI from a field of a JSON which could be `null`.
`BlankableBuilder` is the widget designed to deal with those cases

```dart
Widget build(BuildContext context) {
  return QueryBlocBuilder(
    bloc: context.read<MyStringListBloc>(),
    builder: (_, list) => BlankableBuilder(
      value: list,
      blankBuilder: (_) => Center(child: Text("List is empty")),
      builder: (_, list) => ListView.builder(
        itemCount: list.length,
        itemBuilder: (_, index) => ItemWidget(item: list[index]),
      ),
    );
  )
}
```

`BlankableBuilder` supports empty checking for `List` `Map` `Iterable` and `String` by default, also it treats `null` as empty too.
To make `BlankableBuilder` works with other types, `blankChecker` checker can be provided.


[Bloc_Flutter]:https://pub.dev/packages/flutter_bloc
[Provider]:https://pub.dev/packages/provider