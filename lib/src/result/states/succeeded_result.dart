import 'package:collection/collection.dart';

import '../multi_state_result.dart';

/// State indicates the query is finished successfully
///
/// [value] is the result returned by the query
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
/// * [QueryResult]
/// * [AsyncQueryResult]
abstract class SucceededResult<T> with MultiStateResult implements HasValue<T> {
  /// Return value of the query
  final T value;

  const SucceededResult(this.value);

  @override
  bool operator ==(dynamic other) =>
      const DeepCollectionEquality().equals(this, other) ||
      (other is SucceededResult &&
          const DeepCollectionEquality().equals(other.value, value));

  @override
  int get hashCode =>
      (SucceededResult).hashCode ^
      (T).hashCode ^
      const DeepCollectionEquality().hash(value);

  @override
  String toString() => "ValueResult<$T>: $value";
}
