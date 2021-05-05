import 'base/unit_state_base.dart';

/// State indicates the action haven't started yet
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
abstract class IdleState extends UnitStateBase<IdleState> {
  const IdleState();
}
