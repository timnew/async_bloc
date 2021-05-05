import 'base/value_state_base.dart';

/// State indicates the action haven't started yet, but with preset value
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
abstract class IdleValueState<T> extends ValueStateBase<T, IdleValueState<T>> {
  const IdleValueState(T value) : super(value);
}
