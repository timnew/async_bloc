import 'base/unit_state_base.dart';

/// State indicates the action is in progress
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
abstract class WaitingState extends UnitStateBase<WaitingState> {
  const WaitingState();
}
