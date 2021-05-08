import 'package:collection/collection.dart';

import '../stated.dart';

class ValueErrorStateBase<T, SELF extends HasValueAndError<T>>
    with Stated
    implements HasValueAndError<T> {
  /// Value holds of the state
  final T value;

  /// Error or exception
  final Object error;

  /// Stack trace of the error
  final StackTrace? stackTrace;

  const ValueErrorStateBase(this.value, this.error, [this.stackTrace]);

  @override
  bool operator ==(dynamic other) =>
      const IdentityEquality().equals(this, other) ||
      (other is SELF &&
          const DeepCollectionEquality().equals(other.value, value) &&
          const IdentityEquality().equals(other.error, error) &&
          const IdentityEquality().equals(other.stackTrace, stackTrace));

  @override
  int get hashCode =>
      (SELF).hashCode ^
      (T).hashCode ^
      const IdentityEquality().hash(error) ^
      const IdentityEquality().hash(stackTrace) ^
      const DeepCollectionEquality().hash(value);

  @override
  String toString() => "$SELF($value, $error)";
}
