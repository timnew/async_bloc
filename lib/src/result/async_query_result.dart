import 'function_types.dart';
import 'multi_state_result.dart';
import 'states/pending_result.dart';
import 'states/default_result.dart';
import 'states/busy_result.dart';
import 'states/value_result.dart';
import 'states/failed_result.dart';
import 'util.dart';

/// A 4-state result represents asychronised query with single query value
/// It could be either pending, busy, succeeded, or failed
///
/// Typically used with `Bloc` or `ValueNotifier`
///
/// [AsyncQueryResult] creates the [PendingResult], indicates the query hasn't started
/// [AsyncQueryResult.busy] creates the [BusyResult], indicates the query is in progress
/// [AsyncQueryResult.succeeded] creates the [ValueResult], indicates the query is succeded with a value
/// [AsyncQueryResult.failed] creates the [FailedResult], indicates the query is failed
///
/// Optionally, [AsyncQueryResult.initialValue] can be used to create [DefaultResult],
/// indicates the query hasn't started, but a default value is given.
///
/// See also
/// * [ActionResult]
/// * [AsyncActionResult]
/// * [QueryResult]
abstract class AsyncQueryResult<T> implements MultiStateResult {
  /// Creates the [PendingResult], indicates the query hasn't started
  factory AsyncQueryResult() => const _Pending();

  /// Create [DefaultResult], indicates the query hasn't started but a default value is given.
  const factory AsyncQueryResult.initialValue(T initialValue) = _Default;

  /// Creates the [BusyResult], indicates the query is in progress
  factory AsyncQueryResult.busy() => const _Busy();

  /// Creates the [ValueResult], indicates the query is succeded with a value
  const factory AsyncQueryResult.succeeded(T result) = _Succeeded;

  /// Creates the [FailedResult], indicates the query is failed
  const factory AsyncQueryResult.failed(dynamic error,
      [StackTrace? stackTrace]) = _Failed;

  /// Pattern match the result on all branches
  ///
  /// [pending] is called with action hasn't started
  /// [initialValue] is called when the action isn't started but initialValue is given
  /// [busy] is called when action is in progress
  /// [succeeded] is called if result is succeeded
  /// [failed] is called with error and stackTrace if result is failed
  TR map<TR>({
    required ResultMapper<TR> pending,
    ValueResultMapper<T, TR>? initialValue,
    required ResultMapper<TR> busy,
    required ValueResultMapper<T, TR> succeeded,
    required FailedResultMapper<TR> failed,
  }) =>
      completeMapOr(
        pendingResult: pending,
        defaultResult: initialValue,
        busyResult: busy,
        valueResult: succeeded,
        failedResult: failed,
      );

  /// Pattern match the result with else branch
  ///
  /// [pending] is called with action hasn't started
  /// [initialValue] is called when the action isn't started but initialValue is given
  /// [busy] is called when action is in progress
  /// [succeeded] is called if result is completed
  /// [failed] is called with error and stackTrace if result is failed
  ///
  /// [notStarted] is called on [pending] or [initialValue]. Not called if [pending] or [initialValue] is given.
  /// [finished] is either completed or failed. Not called if [failed] or [succeeded] is given.
  /// [hasValue] is called on [initialValue] or [succeeded]. Not called if [initialValue] or [succeeded] is given.
  ///
  /// [orElse] is called if no specific state mapper is given
  TR mapOr<TR>({
    ResultMapper<TR>? pending,
    ValueResultMapper<T, TR>? initialValue,
    ResultMapper<TR>? busy,
    ValueResultMapper<T, TR>? succeeded,
    FailedResultMapper<TR>? failed,
    ResultMapper<TR>? notStarted,
    ResultMapper<TR>? finished,
    ValueResultMapper<T, TR>? hasValue,
    required ResultMapper<TR> orElse,
  }) =>
      completeMapOr(
        pendingResult: pending,
        busyResult: busy,
        defaultResult: initialValue,
        valueResult: succeeded,
        failedResult: failed,
        isPending: notStarted,
        isFinished: finished,
        hasValue: hasValue,
        orElse: orElse,
      );
}

class _Pending<T> extends PendingResult with AsyncQueryResult<T> {
  const _Pending();
}

class _Default<T> extends DefaultResult<T> with AsyncQueryResult<T> {
  const _Default(T initialValue) : super(initialValue);
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
