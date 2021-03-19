import 'package:collection/collection.dart';

import '../multi_state_result.dart';

/// State indicates the query has not been started yet, but provided with a default initial value
///
/// the [value] is the initial value
///
/// All states:
/// * [PendingResult]
/// * [BusyResult]
/// * [InitialValueResult]
/// * [SucceededResult]
/// * [CompletedResult]
/// * [FailedResult]
///
/// Used by
/// * [AsyncQueryResult]
abstract class InitialValueResult<T>
    with MultiStateResult
    implements HasValue<T> {
  /// Initial value given
  final T value;

  const InitialValueResult(this.value);

  @override
  bool operator ==(dynamic other) =>
      const DeepCollectionEquality().equals(this, other) ||
      (other is InitialValueResult &&
          const DeepCollectionEquality().equals(other.value, value));

  @override
  int get hashCode =>
      (InitialValueResult).hashCode ^
      (T).hashCode ^
      const DeepCollectionEquality().hash(value);

  @override
  String toString() => "ValueResult<$T>: $value";
}
