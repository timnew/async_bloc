import 'package:collection/collection.dart';

import '../../stated_result.dart';

abstract class ValueResultBase<T, SELF extends ValueResult<T>>
    with StatedResult
    implements ValueResult<T> {
  /// The value of the result
  final T value;

  const ValueResultBase(this.value);

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
  String toString() => "$SELF: $value";
}
