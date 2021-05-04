import 'base/unit_result_base.dart';

/// State indicates the action/query has been started but not yet finished
///
/// All states:
/// * [PendingResult]
/// * [WaitingResult]
/// * [InitialValueResult]
/// * [SucceededResult]
/// * [CompletedResult]
/// * [FailedResult]
///
/// Used by
/// * [AsyncActionResult]
/// * [AsyncQueryResult]
abstract class WaitingResult extends UnitResultBase<WaitingResult> {
  const WaitingResult();
}
