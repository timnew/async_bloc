import 'base/unit_state_base.dart';

/// State indicates the action is completed successfully
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
abstract class DoneState extends UnitStateBase<DoneState> {
  const DoneState();
}
