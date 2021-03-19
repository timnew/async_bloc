import 'dart:async';

import 'async_action_result.dart';
import 'contracts.dart';
import 'states/completed_result.dart';
import 'states/failed_result.dart';
import 'stated_result.dart';
import 'util.dart';

/// A 2-state result represents synchronised action with no return value
/// It could be either succeeded or failed
///
/// Typically wrapped in a future as the return value of an action execution.
/// ```dart
/// Future<ActionResult> deleteObject(String id);
/// ```
///
/// [ActionResult.completed] creates the [CompletedResult], indicates the action is completed
/// [ActionResult.failed] creates the [FailedResult], indicates the action is failed
///
/// See also
/// * [AsyncActionResult]
/// * [QueryResult]
/// * [AsyncQueryResult]
abstract class ActionResult implements StatedResult {
  /// creates the [CompletedResult]
  /// This factory always returns a const result
  factory ActionResult.completed() => const _Completed();

  /// creates the [FailedResult]
  /// [error] is the [Error]/[Exception] fails the action
  /// [stackTrace] indicates where the [error] was thrown, it is optional
  const factory ActionResult.failed(dynamic error, [StackTrace? stackTrace]) =
      _Failed;

  /// Pattern match the result
  ///
  /// [completed] is called if result is completed
  /// [failed] is called with error and stackTrace if result is failed
  TR map<TR>({
    required ResultMapper<TR> completed,
    required FailedResultMapper<TR> failed,
  }) =>
      completeMapOr<Never, TR>(
        completedResult: completed,
        failedResult: failed,
      );

  /// Convert the [ActionResult] into [AsyncActionResult] with corresponding state
  AsyncActionResult asAsyncResult() => map(
        completed: () => AsyncActionResult.completed(),
        failed: (result) =>
            AsyncActionResult.failed(result.error, result.stackTrace),
      );
}

class _Completed extends CompletedResult with ActionResult {
  const _Completed();
}

class _Failed extends FailedResult with ActionResult {
  const _Failed(dynamic error, [StackTrace? stackTrace])
      : super(error, stackTrace);
}

/// Provides extension methods on `Future` for [ActionResult]
extension ActionResultFutureExtension on Future {
  /// Materialize `Future` into `Future<ActionResult>`]
  ///
  /// Materialised future always succeed
  /// Returns [CompletedResult] if future resovled succesfully
  /// Returns [FailedResult] if future throws
  ///
  /// If input future contains [ActionResult] or [QueryResult],
  /// the result is flattened automatically.
  ///
  /// If input future contains [AsyncActionResult] or [AsyncQueryResult],
  /// only [SucceededResult], [CompletedResult], [FailedResult] are flattened automatically.
  /// Other values would cause exception.
  Future<ActionResult> asActionResult() async {
    try {
      final result = await this;

      if (result is StatedResult) {
        return result.completeMapOr(
          isSucceeded: () => ActionResult.completed(),
          failedResult: (result) =>
              ActionResult.failed(result.error, result.stackTrace),
        );
      }

      return ActionResult.completed();
    } catch (error, stackTrace) {
      return ActionResult.failed(error, stackTrace);
    }
  }
}

/// Provides extension methods on `Future<ActionResult>` for [ActionResult]
extension FutureActionResultExtension on Future<ActionResult> {
  /// Same as `ActionResult.asAsyncResult` provided by [ActionResultFutureExtension] but applies on Future
  /// Convert Future of [ActionResult] to Future of [AsyncActionResult]
  Future<AsyncActionResult> asAsyncResult() async =>
      (await this).asAsyncResult();
}
