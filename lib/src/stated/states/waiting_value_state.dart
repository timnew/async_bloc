import 'base/value_state_base.dart';

/// State indicates the action is in progress, but also with a value
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
abstract class WaitingValueState<T>
    extends ValueStateBase<T, WaitingValueState<T>> {
  const WaitingValueState(T value) : super(value);
}
