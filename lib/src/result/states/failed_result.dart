import 'package:collection/collection.dart';

import '../multi_state_result.dart';

/// State indicates the query/action is failed
///
/// [error] is the captured exception/error
/// [stackTrace] might be available indicates where the error was thrown
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
/// * [ActionResult]
/// * [QueryResult]
/// * [AsyncActionResult]
/// * [AsyncQueryResult]
abstract class FailedResult with MultiStateResult {
  /// Error or exception caught
  final dynamic error;

  /// Stack trace of the error
  final StackTrace? stackTrace;

  const FailedResult(this.error, this.stackTrace);

  @override
  bool operator ==(dynamic other) =>
      const DeepCollectionEquality().equals(this, other) ||
      (other is FailedResult &&
          const DeepCollectionEquality().equals(other.error, error) &&
          const DeepCollectionEquality().equals(other.stackTrace, stackTrace));

  @override
  int get hashCode =>
      (FailedResult).hashCode ^
      const DeepCollectionEquality().hash(error) ^
      const DeepCollectionEquality().hash(stackTrace);

  @override
  String toString() => "FailedResult: $error\n$stackTrace";
}
