import 'abstract/unit_result_base.dart';

/// State indicates the action is completed successfully
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
/// * [AsyncActionResult]
abstract class CompletedResult extends UnitResultBase<CompletedResult> {
  const CompletedResult();
}
