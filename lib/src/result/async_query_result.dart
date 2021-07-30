import 'package:stated_result/stated.dart';

import 'action_result.dart';
import 'query_result.dart';
import 'async_action_result.dart';

/// A type represents the result of a async query.
///
/// [AsyncQueryResult.idle] creates the [IdleState], indicates the query hasn't started
/// [AsyncQueryResult.preset] creates the [IdleValueState], indicates the query hasn't started, but has a preset value
/// [AsyncQueryResult.working] creates the [WorkingState], indicates the query is in progress
/// [AsyncQueryResult.succeeded] creates the [SucceededState], indicates the query is completed
/// [AsyncQueryResult.failed] creates the [FailedState], indicates the query is failed
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

  /// Creates a [AsyncQueryResult] in [SucceededValueState]
  const factory AsyncQueryResult.succeeded(T value) = _Succeeded;

  /// creates a [AsyncQueryResult] in [FailedState] with [error]
  const factory AsyncQueryResult.failed(Object error) = _Failed;

  /// creates an [AsyncQueryResult] from [value].
  /// If `value` is `null`, [IdleState] is created
  /// Otherwise [SucceededValueState] with `value` is created
  factory AsyncQueryResult.fromValue(T? value) => value == null
      ? AsyncQueryResult.idle()
      : AsyncQueryResult.succeeded(value);

  /// Create [AsyncQueryResult] from other [Stated] types
  /// * [IdleState] converts to [AsyncQueryResult.idle]
  /// * [IdleValueState] converts to [AsyncQueryResult.preset]
  /// * [WorkingState] or [WorkingValueState] converts to [AsyncQueryResult.working]
  /// * [SucceededValueState] converts to [AsyncQueryResult.succeeded]
  /// * [FailedState] or [FailedValueState] converts to [AsyncActionResult.failed]
  ///  Otherwise [UnsupportedError] is thrown
  factory AsyncQueryResult.from(Stated other) {
    if (other is IdleState) return AsyncQueryResult.idle();
    if (other is IdleValueState<T>) {
      return AsyncQueryResult.preset(other.extractValue());
    }
    if (other.isWorking) return AsyncQueryResult.working();
    if (other is SucceededValueState<T>) {
      return AsyncQueryResult.succeeded(other.value);
    }
    if (other.isFailed) return AsyncQueryResult.failed(other.extractError());

    throw UnsupportedError(
      "$other in the state not supported by AsyncQueryResult",
    );
  }

  /// Pattern match the result on all branches
  TR map<TR>({
    required StateTransformer<TR> idle,
    ValueTransformer<T, TR>? preset,
    required StateTransformer<TR> working,
    required ValueTransformer<T, TR> completed,
    required ValueTransformer<Object, TR> failed,
  }) {
    if (this is _Idle) return idle();
    if (this is _Preset) {
      if (preset != null) return preset(this.extractValue());
      return idle();
    }
    if (this is _Working) return working();
    if (this is _Succeeded) return completed(this.extractValue());
    return failed(this.extractError());
  }

  /// emit [AsyncQueryResult.working] and then [AsyncQueryResult.succeeded] or [AsyncQueryResult.failed] based on the [future]'s result.
  /// [emit] used to receive the the update
  ///
  /// `async generator` can't be used here, due to a issue in language: https://github.com/dart-lang/language/issues/1625
  Future<void> updateWith<U>(
    Future<U> future,
    void emit(AsyncQueryResult<U> value),
  ) async {
    if (isWorking) throw StateError("Parallel update with future");

    emit(AsyncQueryResult.working());

    final result = await future.asQueryResult();

    emit(AsyncQueryResult<U>.from(result));
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

class _Succeeded<T> extends SucceededValueState<T> with AsyncQueryResult<T> {
  const _Succeeded(T value) : super(value);
}

class _Failed<T> extends FailedState with AsyncQueryResult<T> {
  const _Failed(Object error) : super(error);
}
