import 'function_types.dart';
import 'states/completed_result.dart';
import 'states/failed_result.dart';
import 'states/pending_result.dart';
import 'states/busy_result.dart';
import 'multi_state_result.dart';
import 'util.dart';

abstract class AsyncActionResult implements MultiStateResult {
  factory AsyncActionResult() => const _Pending();
  factory AsyncActionResult.busy() => const _Busy();
  factory AsyncActionResult.completed() => const _Completed();
  const factory AsyncActionResult.failed(dynamic error,
      [StackTrace? stackTrace]) = _Failed;

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
