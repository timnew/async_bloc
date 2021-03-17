import 'async_query_result.dart';
import 'function_types.dart';
import 'state_values/multi_state_result.dart';
import 'state_values/value_result.dart';
import 'state_values/failed_result.dart';
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

  AsyncQueryResult<T> asyncQueryResult() => map(
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
