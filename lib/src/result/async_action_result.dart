import 'package:stated_result/stated.dart';

import 'action_result.dart';
import 'query_result.dart';
import 'async_query_result.dart';

/// A type represents the result of a async action.
///
/// [AsyncActionResult.idle] creates the [IdleState], indicates the action hasn't started
/// [AsyncActionResult.working] creates the [WorkingState], indicates the action is in progress
/// [AsyncActionResult.completed] creates the [DoneState], indicates the action is completed
/// [AsyncActionResult.failed] creates the [ErrorState], indicates the action is failed
///
/// See also
/// * [ActionResult]
/// * [QueryResult]
/// * [AsyncQueryResult]
abstract class AsyncActionResult implements Stated {
  /// Alias to [AsyncActionResult.idle]
  factory AsyncActionResult() = AsyncActionResult.idle;

  /// Creates a [AsyncActionResult] in [IdleState]
  /// This factory always returns a const result
  factory AsyncActionResult.idle() => const _Idle();

  /// Creates a [AsyncActionResult] in [WorkingState]
  /// This factory always returns a const result
  factory AsyncActionResult.working() => const _Working();

  /// Creates a [AsyncActionResult] in [DoneState]
  /// This factory always returns a const result
  factory AsyncActionResult.completed() => const _Completed();

  /// creates a [AsyncActionResult] in [ErrorState] with [error] and optional [stackTrace]
  const factory AsyncActionResult.failed(
    Object error, [
    StackTrace? stackTrace,
  ]) = _Failed;

  /// creates an [AsyncActionResult] in [ErrorState] from [errorInfo]
  factory AsyncActionResult.fromError(HasError errorInfo) = _Failed.fromError;

  /// Create [AsyncActionResult] from other [Stated] types
  /// * [IdleState] or [IdleValueState] converts to [AsyncActionResult.idle]
  /// * [WorkingState] or [WorkingValueState] converts to [AsyncActionResult.working]
  /// * [DoneValueState] or [DoneState] converts to [AsyncActionResult.completed]
  /// * [ErrorState] or [ErrorValueState] converts to [AsyncActionResult.failed]
  ///  Otherwise [UnsupportedError] is thrown
  factory AsyncActionResult.from(Stated other) {
    if (other.isIdle) return AsyncActionResult.idle();
    if (other.isWorking) return AsyncActionResult.working();
    if (other.isSucceeded) return AsyncActionResult.completed();
    if (other.isFailed) return AsyncActionResult.fromError(other.asError());
    throw UnsupportedError(
      "$other in the state not supported by AsyncActionResult",
    );
  }

  /// Pattern match the result on all branches
  TR map<TR>({
    required StateTransformer<TR> idle,
    required StateTransformer<TR> working,
    required StateTransformer<TR> completed,
    required ValueTransformer<HasError, TR> failed,
  }) {
    if (this is _Idle) return idle();
    if (this is _Working) return working();
    if (this is _Completed) return completed();
    return failed(this.asError());
  }
}

class _Idle extends IdleState with AsyncActionResult {
  const _Idle();
}

class _Working extends WorkingState with AsyncActionResult {
  const _Working();
}

class _Completed extends DoneState with AsyncActionResult {
  const _Completed();
}

class _Failed extends ErrorState with AsyncActionResult {
  const _Failed(Object error, [StackTrace? stackTrace])
      : super(error, stackTrace);

  _Failed.fromError(HasError errorInfo)
      : this(errorInfo.error, errorInfo.stackTrace);
}
