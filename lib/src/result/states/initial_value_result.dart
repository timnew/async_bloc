import 'abstract/value_result_base.dart';

/// State indicates the query has not been started yet, but provided with a default initial value
///
/// the [value] is the initial value
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
/// * [AsyncQueryResult]
abstract class InitialValueResult<T>
    extends ValueResultBase<T, InitialValueResult<T>> {
  const InitialValueResult(T value) : super(value);
}
