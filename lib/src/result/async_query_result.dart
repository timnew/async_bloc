import 'contracts.dart';
import 'stated_result.dart';
import 'states/pending_result.dart';
import 'states/initial_value_result.dart';
import 'states/waiting_result.dart';
import 'states/succeeded_result.dart';
import 'states/failed_result.dart';
import 'util.dart';

import 'action_result.dart';
import 'query_result.dart';
import 'async_action_result.dart';

/// A 4-state result represents asychronised query with single query value
/// It could be either pending, waiting, succeeded, or failed
///
/// Typically used with `Bloc` or `ValueNotifier`
///
/// [AsyncQueryResult.pending] creates the [PendingResult], indicates the query hasn't started.
/// [AsyncQueryResult.waiting] creates the [WaitingResult], indicates the query is in progress
/// [AsyncQueryResult.succeeded] creates the [SucceededResult], indicates the query is succeded with a value
/// [AsyncQueryResult.failed] creates the [FailedResult], indicates the query is failed
///
/// Optionally, [AsyncQueryResult.initialValue] can be used to create [InitialValueResult],
/// indicates the query hasn't started, but a default value is given.
///
/// See also
/// * [ActionResult]
/// * [AsyncActionResult]
/// * [QueryResult]
abstract class AsyncQueryResult<T> implements StatedResult {
  /// Alias to [AsyncQueryResult.pending]
  factory AsyncQueryResult() = AsyncQueryResult.pending;

  /// Creates the [PendingResult], indicates the query hasn't started
  factory AsyncQueryResult.pending() => const _Pending();

  /// Create [InitialValueResult], indicates the query hasn't started but a default value is given.
  const factory AsyncQueryResult.initialValue(T initialValue) = _Default;

  /// Creates the [WaitingResult], indicates the query is in progress
  factory AsyncQueryResult.waiting() => const _Waiting();

  /// Creates the [SucceededResult], indicates the query is succeded with a value
  const factory AsyncQueryResult.succeeded(T result) = _Succeeded;

  /// Creates the [FailedResult], indicates the query is failed
  const factory AsyncQueryResult.failed(dynamic error,
      [StackTrace? stackTrace]) = _Failed;

  /// Pattern match the result on all branches
  ///
  /// [pending] is called with action hasn't started
  /// [initialValue] is called when the action isn't started but initialValue is given
  /// [waiting] is called when action is in progress
  /// [succeeded] is called if result is succeeded
  /// [failed] is called with error and stackTrace if result is failed
  TR map<TR>({
    required ResultMapper<TR> pending,
    ValueResultMapper<T, TR>? initialValue,
    required ResultMapper<TR> waiting,
    required ValueResultMapper<T, TR> succeeded,
    required FailedResultMapper<TR> failed,
  }) =>
      completeMapOr(
        pendingResult: pending,
        defaultResult: initialValue,
        waitingResult: waiting,
        valueResult: succeeded,
        failedResult: failed,
      );

  /// Pattern match the result with else branch
  ///
  /// [pending] is called with action hasn't started
  /// [initialValue] is called when the action isn't started but initialValue is given
  /// [waiting] is called when action is in progress
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
    ResultMapper<TR>? waiting,
    ValueResultMapper<T, TR>? succeeded,
    FailedResultMapper<TR>? failed,
    ResultMapper<TR>? notStarted,
    ResultMapper<TR>? finished,
    ValueResultMapper<T, TR>? hasValue,
    required ResultMapper<TR> orElse,
  }) =>
      completeMapOr(
        pendingResult: pending,
        waitingResult: waiting,
        defaultResult: initialValue,
        valueResult: succeeded,
        failedResult: failed,
        isNotStarted: notStarted,
        isFinished: finished,
        hasValue: hasValue,
        orElse: orElse,
      );
}

class _Pending<T> extends PendingResult with AsyncQueryResult<T> {
  const _Pending();
}

class _Default<T> extends InitialValueResult<T> with AsyncQueryResult<T> {
  const _Default(T initialValue) : super(initialValue);
}

class _Waiting<T> extends WaitingResult with AsyncQueryResult<T> {
  const _Waiting();
}

class _Succeeded<T> extends SucceededResult<T> with AsyncQueryResult<T> {
  const _Succeeded(T value) : super(value);
}

class _Failed<T> extends FailedResult with AsyncQueryResult<T> {
  const _Failed(dynamic error, [StackTrace? stackTrace])
      : super(error, stackTrace);
}
