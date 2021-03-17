import 'package:collection/collection.dart';

import '../multi_state_result.dart';

abstract class DefaultResult<T> with MultiStateResult implements HasValue<T> {
  final T value;

  const DefaultResult(this.value);

  @override
  bool operator ==(dynamic other) =>
      const DeepCollectionEquality().equals(this, other) ||
      (other is DefaultResult &&
          const DeepCollectionEquality().equals(other.value, value));

  @override
  int get hashCode =>
      (DefaultResult).hashCode ^
      (T).hashCode ^
      const DeepCollectionEquality().hash(value);

  @override
  String toString() => "ValueResult<$T>: $value";
}
