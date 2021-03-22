import 'dart:async';

import 'action_result.dart';
import 'async_action_result.dart';
import 'async_query_result.dart';
import 'contracts.dart';
import 'stated_result.dart';
import 'states/succeeded_result.dart';
import 'states/failed_result.dart';
import 'util.dart';

/// A 2-state result represents synchronised query with single return value
/// It could be either succeeded or failed
///
/// Typically wrapped in a future as the return value of an action execution.
/// ```dart
/// Future<QueryResult<User>> findUser(String userId);
/// ```
///
/// [QueryResult.succeeded] creates the [SucceededResult], indicates the query is succeded with a value
/// [QueryResult.failed] creates the [FailedResult], indicates the query is failed
///
/// See also
/// * [ActionResult]
/// * [AsyncActionResult]
/// * [AsyncQueryResult]
abstract class QueryResult<T> implements StatedResult {
  /// Alias to [QueryResult.succeeded]
  const factory QueryResult(T value) = QueryResult.succeeded;

  /// Creates the [SucceededResult] with [value]
  const factory QueryResult.succeeded(T value) = _Succeeded;

  /// creates the [FailedResult]
  /// [error] is the [Error]/[Exception] fails the action
  /// [stackTrace] indicates where the [error] was thrown, it is optional
  const factory QueryResult.failed(dynamic error, [StackTrace? stackTrace]) =
      _Failed;

  /// Pattern match the result
  ///
  /// [succeeded] is called with value if result is succeeded
  /// [failed] is called with error and stackTrace if result is failed
  TR map<TR>({
    required ValueResultMapper<T, TR> succeeded,
    required FailedResultMapper<TR> failed,
  }) =>
      completeMapOr<T, TR>(
        valueResult: succeeded,
        failedResult: failed,
      );

  /// Convert the [QueryResult] into [AsyncQueryResult] with corresponding state
  AsyncQueryResult<T> asAsyncResult() => map(
        succeeded: (result) => AsyncQueryResult.succeeded(result.value),
        failed: (result) =>
            AsyncQueryResult.failed(result.error, result.stackTrace),
      );
}

class _Succeeded<T> extends SucceededResult<T> with QueryResult<T> {
  const _Succeeded(T value) : super(value);
}

class _Failed<T> extends FailedResult with QueryResult<T> {
  const _Failed(dynamic error, [StackTrace? stackTrace])
      : super(error, stackTrace);
}

/// Provides extension methods on `Future<T>` for [QueryResult]
extension QueryResultFutureExtension<T> on Future<T> {
  /// Materialize `Future<T>` into `Future<QueryResult<T>>`
  ///
  /// Materialised future always succeed
  /// Returns [SucceededResult] if future resovled succesfully
  /// Returns [FailedResult] if future throws
  Future<QueryResult<T>> asQueryResult() async {
    try {
      final result = await this;

      return QueryResult(result);
    } catch (error, stackTrace) {
      return QueryResult<T>.failed(error, stackTrace);
    }
  }
}

/// Provides extension methods on `Future<QueryResult<T>>` for [QueryResult]
extension FutureQueryResultExtension<T> on Future<QueryResult<T>> {
  /// Same as [QueryResult.asAsyncResult] but applies on Future
  /// Convert Future of [QueryResult] to Future of [AsyncQueryResult]
  Future<AsyncQueryResult<T>> asAsyncResult() async =>
      (await this).asAsyncResult();
}
