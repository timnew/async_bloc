import 'base/unit_result_base.dart';

/// State indicates the action is completed successfully
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
/// * [ActionResult]
/// * [AsyncActionResult]
abstract class CompletedResult extends UnitResultBase<CompletedResult> {
  const CompletedResult();
}
