import 'package:stated_result/src/stated/working_value_state.dart';
import 'package:stated_result/stated_result.dart';

import 'working_state.dart';
import 'done_state.dart';
import 'idle_value_state.dart';
import 'error_state.dart';
import 'idle_state.dart';
import 'done_value_state.dart';

/// Beaviour to find out the type's state
mixin Stated {
  /// Return true if it is idle
  bool get isIdle => this is IdleState || this is IdleValueState;

  /// Return true if it is in progress
  bool get isWorking => this is WorkingState || this is WorkingValueState;

  /// Return true if it is finished, either succeeded or failed
  bool get isFinished => isSucceeded || isFailed;

  /// Return true if it is succeeded
  bool get isSucceeded => this is DoneValueState || this is DoneState;

  /// Return true if it is failed with error
  bool get isFailed => this is ErrorState || this is ErrorValueState;

  /// Return true if it has a value
  bool get hasValue => this is HasValue;

  /// Extract the value
  T asValue<T>() => (this as HasValue<T>).value;

  /// Return true if it has error info
  bool get hasError => this is ErrorInfo;

  /// Extract error info
  ErrorInfo asError() => this as ErrorInfo;
}

/// Contract for state holds value
mixin HasValue<T> {
  /// The given value of the result
  T get value;
}

/// Contract for state holds error information
mixin ErrorInfo {
  /// the exception or error
  Object get error;

  /// The stack trace of the error/exception
  StackTrace? get stackTrace;
}

/// Contract for state implements both [HasValue] and [ErrorInfo] contracts.
mixin HasValueAndError<T> implements HasValue<T>, ErrorInfo {}

// Transformer for state without value
typedef TR StateTransformer<TR>();

/// Transformer for state with value
typedef TR ValueTransformer<T, TR>(T value);
