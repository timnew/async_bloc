import 'abstract/singleton_result_base.dart';

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
abstract class CompletedResult extends StatelessResultBase<CompletedResult> {
  const CompletedResult();
}
