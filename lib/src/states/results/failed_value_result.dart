import 'package:collection/collection.dart';

import '../stated_result.dart';

class FailedValueResult<T> with StatedResult implements ErrorValueResult<T> {
  final T value;
  final Object error;
  final StackTrace? stackTrace;

  const FailedValueResult(this.value, this.error, this.stackTrace);

  @override
  bool operator ==(dynamic other) =>
      const IdentityEquality().equals(this, other) ||
      (other is FailedValueResult<T> &&
          const DeepCollectionEquality().equals(other.value, value) &&
          const IdentityEquality().equals(other.error, error) &&
          const IdentityEquality().equals(other.stackTrace, stackTrace));

  @override
  int get hashCode =>
      (FailedValueResult).hashCode ^
      (T).hashCode ^
      const IdentityEquality().hash(error) ^
      const IdentityEquality().hash(stackTrace) ^
      const DeepCollectionEquality().hash(value);

  @override
  String toString() => "FailedValueResult: $value\n$error\n$stackTrace";
}
