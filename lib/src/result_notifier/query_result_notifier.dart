import 'package:flutter/foundation.dart';

import '../../stated_result.dart';

/// A `ValueNotifier` holds [AsyncQueryResult]
class QueryResultNotifier<T> extends ValueNotifier<AsyncQueryResult<T>> {
  /// Create new ValueNotifier
  ///
  /// Optional [initialState] can be used to set the initial state of the notifier.
  /// [PendingResult] is used if not specified
  QueryResultNotifier([AsyncQueryResult<T>? initialState])
      : super(initialState ?? AsyncQueryResult<T>());

  /// Create new Notifier with given intial value of the query
  /// [DefaultResult] will be used
  QueryResultNotifier.initialValue(T initialValue)
      : super(AsyncQueryResult<T>.initialValue(initialValue));

  /// Update Cubit with a `Future`
  /// `Future` will be materialized first
  Future<AsyncQueryResult<T>> updateWithGeneralFuture(Future<T> future) =>
      updateWithAsyncResult(future.asQueryResult().asAsyncResult());

  /// Update `ValueNotifier` with a `Future` of [ActionResult]
  Future<AsyncQueryResult<T>> updateWithResult(Future<QueryResult<T>> future) =>
      updateWithAsyncResult(future.asAsyncResult());

  /// Update `ValueNotifier` with a `Future` of [AsyncQueryResult<T>]
  Future<AsyncQueryResult<T>> updateWithAsyncResult(
    Future<AsyncQueryResult<T>> future,
  ) async {
    this.value.ensureNotBusy();

    this.value = AsyncQueryResult.busy();

    this.value = await future;

    return this.value;
  }
}
