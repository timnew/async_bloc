import 'contracts.dart';
import 'stated_result.dart';
import 'states/waiting_result.dart';
import 'states/completed_result.dart';
import 'states/initial_value_result.dart';
import 'states/failed_result.dart';
import 'states/pending_result.dart';
import 'states/succeeded_result.dart';

/// Internal StatedResult helpers
extension MultiStateResultExtension on StatedResult {
  /// Internal used unsafe mapping function
  TR unsafeMapOr<T, TR>({
    ResultMapper<TR>? pendingResult,
    ResultMapper<TR>? waitingResult,
    ValueResultMapper<T, TR>? initialValueResult,
    ResultMapper<TR>? completedResult,
    ValueResultMapper<T, TR>? succeededResult,
    FailedResultMapper<TR>? failedResult,
    ValueResultMapper<T, TR>? hasValue,
    ResultMapper<TR>? isNotStarted,
    ResultMapper<TR>? isSucceeded,
    ResultMapper<TR>? isFinished,
    ResultMapper<TR>? orElse,
  }) {
    if (this is PendingResult) {
      if (pendingResult != null) return pendingResult();
    } else if (this is WaitingResult) {
      if (waitingResult != null) return waitingResult();
    } else if (this is InitialValueResult<T>) {
      if (initialValueResult != null) {
        return initialValueResult(this as InitialValueResult<T>);
      }
    } else if (this is CompletedResult) {
      if (completedResult != null) return completedResult();
    } else if (this is SucceededResult<T>) {
      if (succeededResult != null) {
        return succeededResult(this as SucceededResult<T>);
      }
    } else if (this is FailedResult) {
      if (failedResult != null) {
        return failedResult(this as FailedResult);
      }
    }

    if (this is ValueResult<T>) {
      if (hasValue != null) return hasValue(this as ValueResult<T>);
    }
    if (this.isNotStarted) {
      if (isNotStarted != null) return isNotStarted();
    }
    if (this.isSucceeded) {
      if (isSucceeded != null) return isSucceeded();
    }
    if (this.isFinished) {
      if (isFinished != null) return isFinished();
    }

    if (orElse != null) return orElse();

    throw StateError("Unexpected State: $this");
  }

  /// Ensure no trigger parallel running
  /// Throw [StateError] if [isWaiting] returns true
  ///
  /// Can be used as state check before kicking off new action/query to avoid parallel run
  void ensureNoParallelRun() {
    if (this.isWaiting) throw StateError("Parallel run");
  }
}
