import 'dart:async';

import 'action_result.dart';
import 'async_action_result.dart';
import 'async_query_result.dart';
import 'contracts.dart';
import 'stated_result.dart';
import 'states/initial_value_result.dart';
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

  /// Create [QueryResult] from any other result
  ///
  /// [FailedResult] converts to [QueryResult.failed]
  /// [SucceededResult]. [InitialValueResult] with type [T] converts to [QueryResult.succeeded]
  ///  Otherwise [UnsupportedError] is thrown
  factory QueryResult.from(StatedResult result) =>
      result.unsafeMapOr<T, QueryResult<T>>(
        failedResult: (result) =>
            QueryResult.failed(result.error, result.stackTrace),
        hasValue: (result) => QueryResult.succeeded(result.value),
        orElse: () =>
            throw UnsupportedError("Cannot convert $result to QueryResult<$T>"),
      );

  /// Pattern match the result
  ///
  /// [succeeded] is called with value if result is succeeded
  /// [failed] is called with error and stackTrace if result is failed
  TR map<TR>({
    required ValueResultMapper<T, TR> succeeded,
    required FailedResultMapper<TR> failed,
  }) =>
      unsafeMapOr<T, TR>(
        succeededResult: succeeded,
        failedResult: failed,
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
      return QueryResult.succeeded(await this);
    } catch (error, stackTrace) {
      return QueryResult<T>.failed(error, stackTrace);
    }
  }
}
