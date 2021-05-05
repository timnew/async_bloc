import 'package:flutter/foundation.dart';

import '../../stated_result.dart';

/// A `ValueNotifier` holds [AsyncQueryResult]
class QueryResultNotifier<T> extends ValueNotifier<AsyncQueryResult<T>> {
  /// Create new ValueNotifier
  ///
  /// Optional [initialState] can be used to set the initial state of the notifier.
  /// [IdleState] is used if not specified
  QueryResultNotifier([AsyncQueryResult<T>? initialState])
      : super(initialState ?? AsyncQueryResult<T>());

  /// Create new Notifier with given intial value of the query
  /// [IdleValueState] will be used
  QueryResultNotifier.initialValue(T initialValue)
      : super(AsyncQueryResult<T>.preset(initialValue));

  /// Capture the result of a generic aync query
  Future<QueryResult<T>> captureResult(Future<T> future) =>
      updateWith(future.asQueryResult());

  /// Update self with future [QueryResult]
  Future<QueryResult<T>> updateWith(Future<QueryResult<T>> future) async {
    await value.updateWith(future).forEach((v) => this.value = v);

    return QueryResult<T>.from(this.value);
  }
}
