import 'dart:async';

import 'async_query_result.dart';
import 'function_types.dart';
import 'multi_state_result.dart';
import 'states/value_result.dart';
import 'states/failed_result.dart';
import 'util.dart';

/// A 2-state result represents synchronised query with single return value
/// It could be either succeeded or failed
///
/// Typically wrapped in a future as the return value of an action execution.
/// ```dart
/// Future<ActionResult> deleteObject(String id);
/// ```
///
/// [ActionResult]'s default constructor creates the [ValueResult]
/// [ActionResult.failed] creates the [FailedResult]
///
/// See also
/// * [ActionResult]
/// * [AsyncActionResult]
/// * [AsyncQueryResult]
abstract class QueryResult<T> implements MultiStateResult {
  /// Creates the [ValueResult] with [value]
  const factory QueryResult(T value) = _Succeeded;

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
        succeeded: (value) => AsyncQueryResult.succeeded(value),
        failed: (error, callStack) => AsyncQueryResult.failed(error, callStack),
      );
}

class _Succeeded<T> extends ValueResult<T> with QueryResult<T> {
  const _Succeeded(T value) : super(value);
}

class _Failed<T> extends FailedResult with QueryResult<T> {
  const _Failed(dynamic error, [StackTrace? stackTrace])
      : super(error, stackTrace);
}

extension QueryResultFutureExtension<T> on Future<T> {
  /// Materialize [Future<T>] into [Future<QueryResult<T>>]
  ///
  /// Materialised future always succeed
  /// Returns [ValueResult] if future resovled succesfully
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

extension FutureQueryResultExtension<T> on Future<QueryResult<T>> {
  /// Same as [QueryResult.asAsyncResult] but applies on Future
  /// Convert Future of [QueryResult] to Future of [AsyncQueryResult]
  Future<AsyncQueryResult<T>> asAsyncResult() async =>
      (await this).asAsyncResult();
}
