import 'package:stated_result/states.dart';
import 'package:stated_result/internal.dart';

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
  const factory AsyncQueryResult.initialValue(T value) = _Default;

  /// Creates the [WaitingResult], indicates the query is in progress
  factory AsyncQueryResult.waiting() => const _Waiting();

  /// Creates the [SucceededResult], indicates the query is succeded with a value
  const factory AsyncQueryResult.succeeded(T value) = _Succeeded;

  /// Creates the [FailedResult], indicates the query is failed
  const factory AsyncQueryResult.failed(Object error,
      [StackTrace? stackTrace]) = _Failed;

  /// Create the result from [value].
  /// If `value` is `null`, [PendingResult] is created
  /// Otherwise [SucceededResult] holds `value` is created
  factory AsyncQueryResult.fromValue(T? value) => value == null
      ? AsyncQueryResult.pending()
      : AsyncQueryResult.succeeded(value);

  /// Create [AsyncQueryResult] from any other result
  ///
  /// [PendingResult] converts to [AsyncQueryResult.pending]
  /// [InitialValueResult] converts to [AsyncQueryResult.initialValue]
  /// [WaitingResult] converts to [AsyncQueryResult.waiting]
  /// [FailedResult] converts to [AsyncQueryResult.failed]
  /// [SucceededResult] with type [T] converts to [AsyncQueryResult.succeeded]
  ///  Otherwise [UnsupportedError] is thrown
  factory AsyncQueryResult.from(StatedResult result) =>
      result.unsafeMapOr<T, AsyncQueryResult<T>>(
        pendingResult: () => AsyncQueryResult.pending(),
        initialValueResult: (result) =>
            AsyncQueryResult.initialValue(result.value),
        waitingResult: () => AsyncQueryResult.waiting(),
        errorResult: (result) =>
            AsyncQueryResult.failed(result.error, result.stackTrace),
        succeededResult: (result) => AsyncQueryResult.succeeded(result.value),
        orElse: () => throw UnsupportedError(
            "Cannot convert $result to AsyncQueryResult"),
      );

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
    required ErrorResultMapper<TR> failed,
  }) =>
      unsafeMapOr(
        pendingResult: pending,
        initialValueResult: initialValue,
        waitingResult: waiting,
        succeededResult: succeeded,
        errorResult: failed,
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
    ErrorResultMapper<TR>? failed,
    ResultMapper<TR>? notStarted,
    ResultMapper<TR>? finished,
    ValueResultMapper<T, TR>? hasValue,
    required ResultMapper<TR> orElse,
  }) =>
      unsafeMapOr(
        pendingResult: pending,
        waitingResult: waiting,
        initialValueResult: initialValue,
        succeededResult: succeeded,
        errorResult: failed,
        isNotStarted: notStarted,
        isFinished: finished,
        hasValue: hasValue,
        orElse: orElse,
      );

  /// Update self with future [QueryResult]
  Stream<AsyncQueryResult<TR>> updateWith<TR>(
      Future<QueryResult<TR>> future) async* {
    ensureNoParallelRun();

    yield AsyncQueryResult.waiting();

    try {
      yield AsyncQueryResult.from(await future);
    } catch (error, stackTrace) {
      yield AsyncQueryResult.failed(error, stackTrace);
    }
  }

  /// map the value of query.
  /// If it is a [SucceededResult] or [InitialValueResult], map its value with [mapper].
  /// Otherwise, keep the result.
  AsyncQueryResult<TR> mapValue<TR>(
    ValueMapper<T, TR> mapper,
  ) =>
      mapOr(
        succeeded: (r) => AsyncQueryResult.succeeded(mapper(r.value)),
        initialValue: (r) => AsyncQueryResult.initialValue(mapper(r.value)),
        failed: (r) => AsyncQueryResult.failed(r.error, r.stackTrace),
        orElse: () => this as AsyncQueryResult<TR>,
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
  const _Failed(Object error, [StackTrace? stackTrace])
      : super(error, stackTrace);
}
