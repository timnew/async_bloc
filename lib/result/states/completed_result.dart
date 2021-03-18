import '../multi_state_result.dart';

/// State indicates the action is completed successfully
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
/// * [AsyncActionResult]
abstract class CompletedResult with MultiStateResult {
  const CompletedResult();

  @override
  bool operator ==(dynamic other) =>
      other is CompletedResult && other.runtimeType == runtimeType;

  @override
  int get hashCode => (CompletedResult).hashCode;

  @override
  String toString() => "CompletedResult";
}
