import 'dart:async';

import 'async_query_result.dart';
import 'function_types.dart';
import 'multi_state_result.dart';
import 'states/value_result.dart';
import 'states/failed_result.dart';
import 'util.dart';

abstract class QueryResult<T> implements MultiStateResult {
  factory QueryResult(T result) => _Succeeded(result);
  factory QueryResult.failed(dynamic error, [StackTrace? stackTrace]) =>
      _Failed(error, stackTrace);

  TR map<TR>({
    required ValueResultMapper<T, TR> succeeded,
    required FailedResultMapper<TR> failed,
  }) =>
      completeMapOr<T, TR>(
        valueResult: succeeded,
        failedResult: failed,
      );

  AsyncQueryResult<T> asAsyncResult() => map(
        succeeded: (value) => AsyncQueryResult.succeeded(value),
        failed: (error, callStack) => AsyncQueryResult.failed(error, callStack),
      );
}

class _Succeeded<T> extends ValueResult<T> with QueryResult<T> {
  const _Succeeded(T value) : super(value);
}

class _Failed<T> extends FailedResult with QueryResult<T> {
  _Failed(dynamic error, StackTrace? stackTrace) : super(error, stackTrace);
}

extension QueryResultFutureOrExtension<T> on FutureOr<QueryResult<T>> {
  Future<AsyncQueryResult<T>> asAsyncResult() async =>
      (await this).asAsyncResult();
}

extension QueryResultFutureExtension<T> on Future<QueryResult<T>> {
  Future<AsyncQueryResult<T>> asAsyncResult() async =>
      (await this).asAsyncResult();
}
