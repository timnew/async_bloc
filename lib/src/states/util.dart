import 'package:stated_result/stated_result.dart';

import 'stated_result.dart';
import 'results/waiting_result.dart';
import 'results/completed_result.dart';
import 'results/initial_value_result.dart';
import 'results/pending_result.dart';
import 'results/succeeded_result.dart';

/// Internal StatedResult helpers
extension MultiStateResultExtension on StatedResult {
  /// Internal used unsafe mapping function
  TR unsafeMapOr<T, TR>({
    ResultMapper<TR>? pendingResult,
    ValueResultMapper<T, TR>? initialValueResult,
    ResultMapper<TR>? waitingResult,
    ValueResultMapper<T, TR>? waitingValueResult,
    ResultMapper<TR>? completedResult,
    ValueResultMapper<T, TR>? succeededResult,
    ErrorResultMapper<TR>? errorResult,
    ErrorValueResultMapper<T, TR>? errorValueResult,
    ValueResultMapper<T, TR>? hasValue,
    ErrorResultMapper<TR>? hasError,
    ResultMapper<TR>? isNotStarted,
    ResultMapper<TR>? isWaiting,
    ResultMapper<TR>? isSucceeded,
    ResultMapper<TR>? isFinished,
    ResultMapper<TR>? orElse,
  }) {
    if (this is PendingResult) {
      if (pendingResult != null) return pendingResult();
    } else if (this is InitialValueResult<T>) {
      if (initialValueResult != null) {
        return initialValueResult(this as InitialValueResult<T>);
      }
    } else if (this is WaitingResult) {
      if (waitingResult != null) return waitingResult();
    } else if (this is WaitingValueResult<T>) {
      if (waitingValueResult != null) {
        return waitingValueResult(this as WaitingValueResult<T>);
      }
    } else if (this is CompletedResult) {
      if (completedResult != null) return completedResult();
    } else if (this is SucceededResult<T>) {
      if (succeededResult != null) {
        return succeededResult(this as SucceededResult<T>);
      }
    } else if (this is ErrorResult) {
      if (errorResult != null) {
        return errorResult(this as ErrorResult);
      }
    } else if (this is ErrorValueResult<T>) {
      if (errorValueResult != null) {
        return errorValueResult(this as ErrorValueResult<T>);
      }
    }

    if (this is ErrorResult) {
      if (hasError != null) return hasError(this as ErrorResult);
    }
    if (this is ValueResult<T>) {
      if (hasValue != null) return hasValue(this as ValueResult<T>);
    }
    if (this.isWaiting) {
      if (isWaiting != null) return isWaiting();
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
