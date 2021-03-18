import '../multi_state_result.dart';

/// State indicates the query/action hasn't started yet
///
/// Pending is the default state of any async action/query
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
/// * [AsyncActionResult]
/// * [AsyncQueryResult]
abstract class PendingResult with MultiStateResult {
  const PendingResult();

  @override
  bool operator ==(dynamic other) =>
      other is PendingResult && other.runtimeType == runtimeType;

  @override
  int get hashCode => (PendingResult).hashCode;

  @override
  String toString() => "PendingResult";
}
