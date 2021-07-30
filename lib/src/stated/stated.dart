import 'package:stated_result/stated_value.dart';

import 'error_value_state.dart';
import 'working_state.dart';
import 'done_state.dart';
import 'idle_value_state.dart';
import 'error_state.dart';
import 'idle_state.dart';
import 'done_value_state.dart';
import 'working_value_state.dart';

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
  T extractValue<T>() => (this as HasValue<T>).value;

  /// Return true if it has error
  bool get hasError => this is HasError;

  /// Extract error or exception
  Object extractError() => (this as HasError).error;
}

/// Contract for state holds value
mixin HasValue<T> {
  /// The given value of the result
  T get value;
}

mixin HasError {
  /// the exception or error
  Object get error;
}

extension HasErrorExtension on HasError {
  bool isErrorA<T>() => error is T;
  T castErrorAs<T>() => error as T;
}

/// Contract for state implements both [HasValue] and [HasError] contracts.
mixin HasValueAndError<T> implements HasValue<T>, HasError {}

// Transformer for state without value
typedef TR StateTransformer<TR>();

/// Transformer for state with value
typedef TR ValueTransformer<T, TR>(T value);
