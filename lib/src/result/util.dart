import 'function_types.dart';
import 'stated_result.dart';
import 'states/busy_result.dart';
import 'states/completed_result.dart';
import 'states/initial_value_result.dart';
import 'states/failed_result.dart';
import 'states/pending_result.dart';
import 'states/succeeded_result.dart';
import 'value_result.dart';

/// Internal use utils
extension MultiStateResultExtension on StatedResult {
  /// Internal used unsafe mapping function
  TR completeMapOr<T, TR>({
    ResultMapper<TR>? pendingResult,
    ResultMapper<TR>? busyResult,
    ValueResultMapper<T, TR>? defaultResult,
    ResultMapper<TR>? completedResult,
    ValueResultMapper<T, TR>? valueResult,
    FailedResultMapper<TR>? failedResult,
    ValueResultMapper<T, TR>? hasValue,
    ResultMapper<TR>? isNotStarted,
    ResultMapper<TR>? isSucceeded,
    ResultMapper<TR>? isFinished,
    ResultMapper<TR>? orElse,
  }) {
    if (this is PendingResult) {
      if (pendingResult != null) return pendingResult();
    } else if (this is BusyResult) {
      if (busyResult != null) return busyResult();
    } else if (this is InitialValueResult<T>) {
      if (defaultResult != null) {
        return defaultResult(this as InitialValueResult<T>);
      }
    } else if (this is CompletedResult) {
      if (completedResult != null) return completedResult();
    } else if (this is SucceededResult<T>) {
      if (valueResult != null) {
        return valueResult(this as SucceededResult<T>);
      }
    } else if (this is FailedResult) {
      if (failedResult != null) {
        return failedResult(this as FailedResult);
      }
    }

    if (this is ValueResult<T>) {
      if (hasValue != null) return hasValue(this as ValueResult<T>);
    } else if (this.isNotStarted) {
      if (isNotStarted != null) return isNotStarted();
    } else if (this.isSucceeded) {
      if (isSucceeded != null) return isSucceeded();
    } else if (this.isFinished) {
      if (isFinished != null) return isFinished();
    }

    if (orElse != null) return orElse();

    throw StateError("Unexpected State: $this");
  }
}
