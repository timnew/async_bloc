import 'dart:async';

import 'async_action_result.dart';
import 'function_types.dart';
import 'state_values/completed_result.dart';
import 'state_values/failed_result.dart';
import 'multi_state_result.dart';
import 'util.dart';

abstract class ActionResult implements MultiStateResult {
  factory ActionResult.completed() => const _Completed();
  const factory ActionResult.failed(dynamic error, [StackTrace? stackTrace]) =
      _Failed;

  TR map<TR>({
    required ResultMapper<TR> completed,
    required FailedResultMapper<TR> failed,
  }) =>
      completeMapOr<Never, TR>(
        completedResult: completed,
        failedResult: failed,
      );

  AsyncActionResult asyncActionResult() => map(
        completed: () => AsyncActionResult.completed(),
        failed: (error, callStack) =>
            AsyncActionResult.failed(error, callStack),
      );
}

class _Completed extends CompletedResult with ActionResult {
  const _Completed();
}

class _Failed extends FailedResult with ActionResult {
  const _Failed(dynamic error, [StackTrace? stackTrace])
      : super(error, stackTrace);
}

extension ActionResultFutureOrExtension on FutureOr<ActionResult> {
  Future<AsyncActionResult> asAsyncResult() async =>
      (await this).asyncActionResult();
}

extension ActionResultFutureExtension on Future<ActionResult> {
  Future<AsyncActionResult> asAsyncResult() async =>
      (await this).asyncActionResult();
}
