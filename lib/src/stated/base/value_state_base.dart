import 'package:collection/collection.dart';

import '../stated.dart';

/// Base class for state implements [HasValue] contract
abstract class ValueStateBase<T, SELF extends HasValue<T>>
    with Stated
    implements HasValue<T> {
  /// Value of the state
  final T value;

  const ValueStateBase(this.value);

  @override
  bool operator ==(dynamic other) =>
      const IdentityEquality().equals(this, other) ||
      (other is SELF &&
          const DeepCollectionEquality().equals(other.value, value));

  @override
  int get hashCode =>
      (SELF).hashCode ^
      (T).hashCode ^
      const DeepCollectionEquality().hash(value);

  @override
  String toString() => "$SELF($value)";
}
