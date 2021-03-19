import 'abstract/value_result_base.dart';

/// State indicates the query is finished successfully
///
/// [value] is the result returned by the query
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
/// * [QueryResult]
/// * [AsyncQueryResult]
abstract class SucceededResult<T>
    extends ValueResultBase<T, SucceededResult<T>> {
  const SucceededResult(T value) : super(value);
}
