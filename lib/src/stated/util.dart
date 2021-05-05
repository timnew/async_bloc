import 'package:stated_result/stated_result.dart';

import 'stated.dart';
import 'states/waiting_state.dart';
import 'states/done_state.dart';
import 'states/idle_value_state.dart';
import 'states/idle_state.dart';
import 'states/done_value_state.dart';

/// Internal StatedResult helpers
extension StatedInternalHelper on Stated {
  /// Internal used unsafe mapping function
  TR unsafeMapOr<T, TR>({
    StateTransformer<TR>? idle,
    ValueTransformer<HasValue<T>, TR>? idleValue,
    StateTransformer<TR>? waiting,
    ValueTransformer<HasValue<T>, TR>? waitingValue,
    StateTransformer<TR>? done,
    ValueTransformer<HasValue<T>, TR>? doneValue,
    ValueTransformer<HasError, TR>? error,
    ValueTransformer<HasValueAndError<T>, TR>? errorValue,
    ValueTransformer<HasValueAndError<T>, TR>? hasValueAndError,
    ValueTransformer<HasValue<T>, TR>? hasValue,
    ValueTransformer<HasError, TR>? hasError,
    StateTransformer<TR>? isNotStarted,
    StateTransformer<TR>? isWaiting,
    StateTransformer<TR>? isSucceeded,
    StateTransformer<TR>? isFinished,
    StateTransformer<TR>? orElse,
  }) {
    if (this is IdleState) {
      if (idle != null) return idle();
    } else if (this is IdleValueState<T>) {
      if (idleValue != null) {
        return idleValue(this as IdleValueState<T>);
      }
    } else if (this is WaitingState) {
      if (waiting != null) return waiting();
    } else if (this is WaitingValueState<T>) {
      if (waitingValue != null) {
        return waitingValue(this as WaitingValueState<T>);
      }
    } else if (this is DoneState) {
      if (done != null) return done();
    } else if (this is DoneValueState<T>) {
      if (doneValue != null) {
        return doneValue(this as DoneValueState<T>);
      }
    } else if (this is HasError) {
      if (error != null) {
        return error(this as HasError);
      }
    } else if (this is HasValueAndError<T>) {
      if (errorValue != null) {
        return errorValue(this as HasValueAndError<T>);
      }
    }

    if (this.hasValue && this.hasValue) {
      if (hasValueAndError != null) {
        return hasValueAndError(this as HasValueAndError<T>);
      }
    }
    if (this.hasError) {
      if (hasError != null) return hasError(this as HasError);
    }
    if (this.hasValue) {
      if (hasValue != null) return hasValue(this as HasValue<T>);
    }
    if (this.isWaiting) {
      if (isWaiting != null) return isWaiting();
    }
    if (this.isIdle) {
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
