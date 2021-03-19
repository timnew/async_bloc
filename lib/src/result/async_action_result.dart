import 'contracts.dart';
import 'states/completed_result.dart';
import 'states/failed_result.dart';
import 'states/pending_result.dart';
import 'states/busy_result.dart';
import 'stated_result.dart';
import 'util.dart';

/// A 4-state result represents asychronised action with no return value
/// It could be either pending, busy, succeeded, or failed
///
/// Typically used with `Bloc` or `ValueNotifier`
///
/// [AsyncActionResult] creates the [PendingResult], indicates the action hasn't started
/// [AsyncActionResult.busy] creates the [BusyResult], indicates the action is in progress
/// [AsyncActionResult.completed] creates the [CompletedResult], indicates the action is completed
/// [AsyncActionResult.failed] creates the [FailedResult], indicates the action is failed
///
/// See also
/// * [ActionResult]
/// * [QueryResult]
/// * [AsyncQueryResult]
abstract class AsyncActionResult implements StatedResult {
  /// Creates the [PendingResult], indicates the action hasn't started
  factory AsyncActionResult() => const _Pending();

  /// Creates the [BusyResult], indicates the action is in progress
  factory AsyncActionResult.busy() => const _Busy();

  /// Creates the [CompletedResult], indicates the action is completed
  factory AsyncActionResult.completed() => const _Completed();

  /// Creates the [FailedResult], indicates the action is failed
  const factory AsyncActionResult.failed(dynamic error,
      [StackTrace? stackTrace]) = _Failed;

  /// Pattern match the result on all branches
  ///
  /// [pending] is called with action hasn't started
  /// [busy] is called when action is in progress
  /// [completed] is called if result is completed
  /// [failed] is called with error and stackTrace if result is failed
  TR map<TR>({
    required ResultMapper<TR> pending,
    required ResultMapper<TR> busy,
    required ResultMapper<TR> completed,
    required FailedResultMapper<TR> failed,
  }) =>
      completeMapOr(
        pendingResult: pending,
        busyResult: busy,
        completedResult: completed,
        failedResult: failed,
      );

  /// Pattern match the result with else branch
  ///
  /// [pending] is called with action hasn't started
  /// [busy] is called when action is in progress
  /// [completed] is called if result is completed
  /// [failed] is called with error and stackTrace if result is failed
  ///
  /// [finished] is either completed or failed. Not called if [failed] or [completed] is given.
  ///
  /// [orElse] is called if no specific state mapper is given
  TR mapOr<TR>({
    ResultMapper<TR>? pending,
    ResultMapper<TR>? busy,
    ResultMapper<TR>? completed,
    FailedResultMapper<TR>? failed,
    ResultMapper<TR>? finished,
    required ResultMapper<TR> orElse,
  }) =>
      completeMapOr(
        pendingResult: pending,
        busyResult: busy,
        completedResult: completed,
        failedResult: failed,
        isFinished: finished,
        orElse: orElse,
      );
}

class _Pending extends PendingResult with AsyncActionResult {
  const _Pending();
}

class _Busy extends BusyResult with AsyncActionResult {
  const _Busy();
}

class _Completed extends CompletedResult with AsyncActionResult {
  const _Completed();
}

class _Failed extends FailedResult with AsyncActionResult {
  const _Failed(dynamic error, [StackTrace? stackTrace])
      : super(error, stackTrace);
}
