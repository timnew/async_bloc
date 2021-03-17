import 'function_types.dart';
import 'multi_state_result.dart';
import 'states/busy_result.dart';
import 'states/completed_result.dart';
import 'states/default_result.dart';
import 'states/failed_result.dart';
import 'states/pending_result.dart';
import 'states/value_result.dart';

extension MultiStateResultExtension on MultiStateResult {
  TR completeMapOr<T, TR>({
    ResultMapper<TR>? pendingResult,
    ResultMapper<TR>? busyResult,
    ValueResultMapper<T, TR>? defaultResult,
    ResultMapper<TR>? completedResult,
    ValueResultMapper<T, TR>? valueResult,
    FailedResultMapper<TR>? failedResult,
    ResultMapper<TR>? isPending,
    ResultMapper<TR>? isFinished,
    ResultMapper<TR>? isSucceeded,
    ValueResultMapper<T, TR>? hasValue,
    ResultMapper<TR>? orElse,
  }) {
    if (this is PendingResult) {
      if (pendingResult != null) return pendingResult();
    } else if (this is BusyResult) {
      if (busyResult != null) return busyResult();
    } else if (this is DefaultResult<T>) {
      if (defaultResult != null) {
        return defaultResult((this as DefaultResult<T>).value);
      }
    } else if (this is CompletedResult) {
      if (completedResult != null) return completedResult();
    } else if (this is ValueResult<T>) {
      if (valueResult != null) {
        return valueResult((this as ValueResult<T>).value);
      }
    } else if (this is FailedResult) {
      if (failedResult != null) {
        final result = this as FailedResult;
        return failedResult(result.error, result.stackTrace);
      }
    }

    if (this.isPending) {
      if (isPending != null) return isPending();
    } else if (this.isFinished) {
      if (isFinished != null) return isFinished();
    } else if (this.isSucceeded) {
      if (isSucceeded != null) return isSucceeded();
    } else if (this is HasValue<T>) {
      if (hasValue != null) return hasValue((this as HasValue<T>).value);
    }

    if (orElse != null) return orElse();

    throw StateError("Unexpected State: $this");
  }
}
