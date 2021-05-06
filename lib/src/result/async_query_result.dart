import 'package:stated_result/stated.dart';

import 'action_result.dart';
import 'query_result.dart';
import 'async_action_result.dart';

/// A type represents the result of a async query.
///
/// [AsyncQueryResult.idle] creates the [IdleState], indicates the query hasn't started
/// [AsyncQueryResult.preset] creates the [IdleValueState], indicates the query hasn't started, but has a preset value
/// [AsyncQueryResult.working] creates the [WorkingState], indicates the query is in progress
/// [AsyncQueryResult.completed] creates the [DoneState], indicates the query is completed
/// [AsyncQueryResult.failed] creates the [ErrorState], indicates the query is failed
///
/// See also
/// * [ActionResult]
/// * [QueryResult]
/// * [AsyncActionResult]
abstract class AsyncQueryResult<T> implements Stated {
  /// Alias to [AsyncQueryResult.idle]
  factory AsyncQueryResult() = AsyncQueryResult.idle;

  /// Creates a [AsyncQueryResult] in [IdleState]
  /// This factory always returns a const result
  factory AsyncQueryResult.idle() => const _Idle();

  /// Creates a [AsyncQueryResult] in [IdleValueState] with [value]
  const factory AsyncQueryResult.preset(T value) = _Preset;

  /// Creates a [AsyncQueryResult] in [IdleState] or [IdleValueState]
  /// If [value] is given [AsyncQueryResult] in [IdleValueState] is created
  /// Otherwise [AsyncQueryResult] in [IdleState] is created.
  factory AsyncQueryResult.idleOrPreset([T? value]) =>
      value == null ? AsyncQueryResult.idle() : AsyncQueryResult.preset(value);

  /// Creates a [AsyncQueryResult] in [WorkingState]
  /// This factory always returns a const result
  factory AsyncQueryResult.working() => const _Working();

  /// Creates a [AsyncQueryResult] in [DoneValueState]
  const factory AsyncQueryResult.completed(T value) = _Completed;

  /// creates a [AsyncQueryResult] in [ErrorState] with [error] and optional [stackTrace]
  const factory AsyncQueryResult.failed(
    Object error, [
    StackTrace? stackTrace,
  ]) = _Failed;

  /// creates an [AsyncQueryResult] in [ErrorState] from [errorInfo]
  factory AsyncQueryResult.fromError(HasError errorInfo) = _Failed.fromError;

  /// creates an [AsyncQueryResult] from [value].
  /// If `value` is `null`, [IdleState] is created
  /// Otherwise [DoneValueState] with `value` is created
  factory AsyncQueryResult.fromValue(T? value) => value == null
      ? AsyncQueryResult.idle()
      : AsyncQueryResult.completed(value);

  /// Create [AsyncQueryResult] from other [Stated] types
  /// * [IdleState] converts to [AsyncQueryResult.idle]
  /// * [IdleValueState] converts to [AsyncQueryResult.preset]
  /// * [WorkingState] or [WorkingValueState] converts to [AsyncQueryResult.working]
  /// * [DoneValueState] converts to [AsyncQueryResult.completed]
  /// * [ErrorState] or [ErrorValueState] converts to [AsyncActionResult.failed]
  ///  Otherwise [UnsupportedError] is thrown
  factory AsyncQueryResult.from(Stated other) {
    if (other is IdleState) return AsyncQueryResult.idle();
    if (other is IdleValueState<T>) {
      return AsyncQueryResult.preset(other.asValue());
    }
    if (other.isWorking) return AsyncQueryResult.working();
    if (other is DoneValueState<T>) {
      return AsyncQueryResult.completed(other.value);
    }
    if (other.isFailed) return AsyncQueryResult.fromError(other.asError());

    throw UnsupportedError(
      "$other in the state not supported by AsyncQueryResult",
    );
  }

  /// Pattern match the result on all branches
  TR map<TR>({
    required StateTransformer<TR> idle,
    ValueTransformer<HasValue<T>, TR>? preset,
    required StateTransformer<TR> working,
    required ValueTransformer<HasValue<T>, TR> completed,
    required ValueTransformer<HasError, TR> failed,
  }) {
    if (this is _Idle) return idle();
    if (this is _Preset) {
      if (preset != null) return preset(this.asValue());
      return idle();
    }
    if (this is _Working) return working();
    if (this is _Completed) return completed(this.asValue());
    return failed(this.asError());
  }

  Stream<AsyncQueryResult<T>> updateWith(Future<T> future) async* {
    if (isWorking) throw StateError("Parallel update with future");

    yield AsyncQueryResult.working();

    final result = await future.asQueryResult();

    yield AsyncQueryResult.from(result);
  }
}

class _Idle<T> extends IdleState with AsyncQueryResult<T> {
  const _Idle();
}

class _Preset<T> extends IdleValueState<T> with AsyncQueryResult<T> {
  const _Preset(T initialValue) : super(initialValue);
}

class _Working<T> extends WorkingState with AsyncQueryResult<T> {
  const _Working();
}

class _Completed<T> extends DoneValueState<T> with AsyncQueryResult<T> {
  const _Completed(T value) : super(value);
}

class _Failed<T> extends ErrorState with AsyncQueryResult<T> {
  const _Failed(Object error, [StackTrace? stackTrace])
      : super(error, stackTrace);

  _Failed.fromError(HasError errorInfo)
      : this(errorInfo.error, errorInfo.stackTrace);
}
