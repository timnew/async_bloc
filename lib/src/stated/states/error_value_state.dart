import 'package:collection/collection.dart';

import '../stated.dart';

/// State indicates the action is failed with error but also value, typically when a optmistic updates failed.
///
/// * [error] : exception or error object
/// * [stackTrace] : optional stack trace associated with error
///
/// All states:
/// * [IdleState]
/// * [IdleValueState]
/// * [WaitingResult]
/// * [WaitingValueResult]
/// * [DoneState]
/// * [DoneValueState]
/// * [ErrorState]
/// * [ErrorValueState]
class ErrorValueState<T> with Stated implements HasValueAndError<T> {
  /// Value holds of the state
  final T value;

  /// Error or exception
  final Object error;

  /// Stack trace of the error
  final StackTrace? stackTrace;

  const ErrorValueState(this.value, this.error, this.stackTrace);

  @override
  bool operator ==(dynamic other) =>
      const IdentityEquality().equals(this, other) ||
      (other is ErrorValueState<T> &&
          const DeepCollectionEquality().equals(other.value, value) &&
          const IdentityEquality().equals(other.error, error) &&
          const IdentityEquality().equals(other.stackTrace, stackTrace));

  @override
  int get hashCode =>
      (ErrorValueState).hashCode ^
      (T).hashCode ^
      const IdentityEquality().hash(error) ^
      const IdentityEquality().hash(stackTrace) ^
      const DeepCollectionEquality().hash(value);

  @override
  String toString() => "FailedValueResult: $value\n$error\n$stackTrace";
}
