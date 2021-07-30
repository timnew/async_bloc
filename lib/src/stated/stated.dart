/// Beaviour to find out the type's state
mixin Stated {
  /// Return true if it is idle
  bool get isIdle => false;

  /// Return true if it is in progress
  bool get isWorking => false;

  /// Return true if it is finished, either succeeded or failed
  bool get isFinished => isSucceeded || isFailed;

  /// Return true if it is succeeded
  bool get isSucceeded => false;

  /// Return true if it is failed with error
  bool get isFailed => false;

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
