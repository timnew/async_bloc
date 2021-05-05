import 'base/value_state_base.dart';

/// State indicates the action is completed successfully with value
///
/// All states:
/// * [IdleState]
/// * [IdleValueState]
/// * [WaitingResult]
/// * [WaitingValueResult]
/// * [DoneState]
/// * [DoneValueState]
/// * [ErrorState]
/// * [ErrorValueState]
abstract class DoneValueState<T> extends ValueStateBase<T, DoneValueState<T>> {
  const DoneValueState(T value) : super(value);
}
