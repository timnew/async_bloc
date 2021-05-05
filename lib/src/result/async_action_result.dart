import 'package:stated_result/states.dart';
import 'package:stated_result/internal.dart';

import 'action_result.dart';
import 'query_result.dart';
import 'async_query_result.dart';

/// A 4-state result represents asychronised action with no return value
/// It could be either pending, waiting, succeeded, or failed
///
/// Typically used with `Bloc` or `ValueNotifier`
///
/// [AsyncActionResult.pending] creates the [PendingResult], indicates the action hasn't started
/// [AsyncActionResult.waiting] creates the [WaitingResult], indicates the action is in progress
/// [AsyncActionResult.completed] creates the [CompletedResult], indicates the action is completed
/// [AsyncActionResult.failed] creates the [FailedResult], indicates the action is failed
///
/// See also
/// * [ActionResult]
/// * [QueryResult]
/// * [AsyncQueryResult]

abstract class AsyncActionResult implements StatedResult {
  /// Alias to [AsyncActionResult.pending]
  factory AsyncActionResult() = AsyncActionResult.pending;

  /// Creates the [PendingResult], indicates the action hasn't started
  factory AsyncActionResult.pending() => const _Pending();

  /// Creates the [WaitingResult], indicates the action is in progress
  factory AsyncActionResult.waiting() => const _Waiting();

  /// Creates the [CompletedResult], indicates the action is completed
  factory AsyncActionResult.completed() => const _Completed();

  /// Creates the [FailedResult], indicates the action is failed
  const factory AsyncActionResult.failed(Object error,
      [StackTrace? stackTrace]) = _Failed;

  /// Create [AsyncActionResult] from any other result
  ///
  /// [PendingResult], [InitialValueResult] converts to [AsyncActionResult.pending]
  /// [WaitingResult] converts to [AsyncActionResult.waiting]
  /// [FailedResult] converts to [AsyncActionResult.failed]
  /// [CompletedResult], [SucceededResult] converts to [AsyncActionResult.completed]
  ///  Otherwise [UnsupportedError] is thrown
  factory AsyncActionResult.from(StatedResult result) =>
      result.unsafeMapOr<dynamic, AsyncActionResult>(
        isNotStarted: () => AsyncActionResult.pending(),
        waitingResult: () => AsyncActionResult.waiting(),
        errorResult: (result) =>
            AsyncActionResult.failed(result.error, result.stackTrace),
        isSucceeded: () => AsyncActionResult.completed(),
        orElse: () => throw UnsupportedError(
            "Cannot convert $result to AsyncActionResult"),
      );

  /// Pattern match the result on all branches
  ///
  /// [pending] is called with action hasn't started
  /// [waiting] is called when action is in progress
  /// [completed] is called if result is completed
  /// [failed] is called with error and stackTrace if result is failed
  TR map<TR>({
    required ResultMapper<TR> pending,
    required ResultMapper<TR> waiting,
    required ResultMapper<TR> completed,
    required ErrorResultMapper<TR> failed,
  }) =>
      unsafeMapOr(
        pendingResult: pending,
        waitingResult: waiting,
        completedResult: completed,
        errorResult: failed,
      );

  /// Pattern match the result with else branch
  ///
  /// [pending] is called with action hasn't started
  /// [waiting] is called when action is in progress
  /// [completed] is called if result is completed
  /// [failed] is called with error and stackTrace if result is failed
  ///
  /// [finished] is either completed or failed. Not called if [failed] or [completed] is given.
  ///
  /// [orElse] is called if no specific state mapper is given
  TR mapOr<TR>({
    ResultMapper<TR>? pending,
    ResultMapper<TR>? waiting,
    ResultMapper<TR>? completed,
    ErrorResultMapper<TR>? failed,
    ResultMapper<TR>? finished,
    required ResultMapper<TR> orElse,
  }) =>
      unsafeMapOr(
        pendingResult: pending,
        waitingResult: waiting,
        completedResult: completed,
        errorResult: failed,
        isFinished: finished,
        orElse: orElse,
      );

  /// Update self with future [ActionResult]
  Stream<AsyncActionResult> updateWith(Future<ActionResult> future) async* {
    ensureNoParallelRun();

    yield AsyncActionResult.waiting();

    try {
      yield AsyncActionResult.from(await future);
    } catch (error, stackTrace) {
      yield AsyncActionResult.failed(error, stackTrace);
    }
  }
}

class _Pending extends PendingResult with AsyncActionResult {
  const _Pending();
}

class _Waiting extends WaitingResult with AsyncActionResult {
  const _Waiting();
}

class _Completed extends CompletedResult with AsyncActionResult {
  const _Completed();
}

class _Failed extends FailedResult with AsyncActionResult {
  const _Failed(Object error, [StackTrace? stackTrace])
      : super(error, stackTrace);
}
