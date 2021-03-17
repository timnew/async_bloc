import 'package:collection/collection.dart';

import '../multi_state_result.dart';

/// State indicates the query is finished successfully
///
/// [value] is the result returned by the query
///
/// All states:
/// * [PendingResult]
/// * [BusyResult]
/// * [DefaultResult]
/// * [ValueResult]
/// * [CompletedResult]
/// * [FailedResult]
///
/// Used by
/// * [ActionResult]
/// * [QueryResult]
/// * [AsyncActionResult]
/// * [AsyncQueryResult]
abstract class ValueResult<T> with MultiStateResult implements HasValue<T> {
  final T value;

  const ValueResult(this.value);

  @override
  bool operator ==(dynamic other) =>
      const DeepCollectionEquality().equals(this, other) ||
      (other is ValueResult &&
          const DeepCollectionEquality().equals(other.value, value));

  @override
  int get hashCode =>
      (ValueResult).hashCode ^
      (T).hashCode ^
      const DeepCollectionEquality().hash(value);

  @override
  String toString() => "ValueResult<$T>: $value";
}
