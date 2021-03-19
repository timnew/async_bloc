import 'abstract/unit_result_base.dart';

/// State indicates the query/action hasn't started yet
///
/// Pending is the default state of any async action/query
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
/// * [AsyncActionResult]
/// * [AsyncQueryResult]
abstract class PendingResult extends UnitResultBase<PendingResult> {
  const PendingResult();
}
