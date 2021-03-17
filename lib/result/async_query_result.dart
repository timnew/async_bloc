import 'function_types.dart';
import 'multi_state_result.dart';
import 'state_values/pending_result.dart';
import 'state_values/default_result.dart';
import 'state_values/busy_result.dart';
import 'state_values/value_result.dart';
import 'state_values/failed_result.dart';
import 'util.dart';

abstract class AsyncQueryResult<T> implements MultiStateResult {
  const factory AsyncQueryResult() = _Pending;
  const factory AsyncQueryResult.withDefaultValue(T defaultValue) = _Default;
  const factory AsyncQueryResult.busy() = _Busy;
  const factory AsyncQueryResult.succeeded(T result) = _Succeeded;
  const factory AsyncQueryResult.failed(dynamic error,
      [StackTrace? stackTrace]) = _Failed;

  TR map<TR>({
    required ResultMapper<TR> pending,
    ValueResultMapper<T, TR>? defaultValue,
    required ResultMapper<TR> busy,
    required ValueResultMapper<T, TR> succeeded,
    required FailedResultMapper<TR> failed,
  }) =>
      completeMapOr(
        pendingResult: pending,
        defaultResult: defaultValue,
        busyResult: busy,
        valueResult: succeeded,
        failedResult: failed,
      );

  TR mapOr<TR>({
    ResultMapper<TR>? pending,
    ResultMapper<TR>? busy,
    ValueResultMapper<T, TR>? defaultValue,
    ValueResultMapper<T, TR>? succeeded,
    FailedResultMapper<TR>? failed,
    ResultMapper<TR>? pendingOrDefault,
    ResultMapper<TR>? finished,
    ValueResultMapper<T, TR>? defaultOrSucceeded,
    required ResultMapper<TR> orElse,
  }) =>
      completeMapOr(
        pendingResult: pending,
        busyResult: busy,
        defaultResult: defaultValue,
        valueResult: succeeded,
        failedResult: failed,
        isPending: pendingOrDefault,
        isFinished: finished,
        hasValue: defaultOrSucceeded,
        orElse: orElse,
      );
}

class _Pending<T> extends PendingResult with AsyncQueryResult<T> {
  const _Pending();
}

class _Default<T> extends DefaultResult<T> with AsyncQueryResult<T> {
  const _Default(T defaultValue) : super(defaultValue);
}

class _Busy<T> extends BusyResult with AsyncQueryResult<T> {
  const _Busy();
}

class _Succeeded<T> extends ValueResult<T> with AsyncQueryResult<T> {
  const _Succeeded(T value) : super(value);
}

class _Failed<T> extends FailedResult with AsyncQueryResult<T> {
  const _Failed(dynamic error, [StackTrace? stackTrace])
      : super(error, stackTrace);
}
