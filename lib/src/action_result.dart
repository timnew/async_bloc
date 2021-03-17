import 'package:async_bloc/src/async_action_result.dart';

import 'function_types.dart';
import 'state_values/completed_result.dart';
import 'state_values/failed_result.dart';
import 'state_values/result.dart';
import 'util.dart';

abstract class ActionResult implements Result {
  const factory ActionResult.completed() = _Completed;
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
