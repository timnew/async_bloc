import 'package:collection/collection.dart';

import '../stated.dart';

class ValueErrorStateBase<T, SELF extends HasValueAndError<T>>
    with Stated
    implements HasValueAndError<T> {
  /// Value holds of the state
  final T value;

  /// Error or exception
  final Object error;

  const ValueErrorStateBase(this.value, this.error);

  @override
  bool operator ==(dynamic other) =>
      const IdentityEquality().equals(this, other) ||
      (other is SELF &&
          const DeepCollectionEquality().equals(other.value, value) &&
          const IdentityEquality().equals(other.error, error));

  @override
  int get hashCode =>
      (SELF).hashCode ^
      (T).hashCode ^
      const IdentityEquality().hash(error) ^
      const DeepCollectionEquality().hash(value);

  @override
  String toString() => "$SELF($value, $error)";
}
