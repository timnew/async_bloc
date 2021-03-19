import '../multi_state_result.dart';

/// State indicates the action/query has been started but not yet finished
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
abstract class BusyResult with MultiStateResult {
  const BusyResult();

  @override
  bool operator ==(dynamic other) =>
      other is BusyResult && other.runtimeType == runtimeType;

  @override
  int get hashCode => (BusyResult).hashCode;

  @override
  String toString() => "BusyResult";
}
