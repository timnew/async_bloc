import 'base/singleton_result_base.dart';

/// State indicates the action/query has been started but not yet finished
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
abstract class BusyResult extends SingletonResultBase<BusyResult> {
  const BusyResult();
}
