import 'base/unit_state_base.dart';

/// State indicates the action is completed successfully
class SucceededState extends UnitStateBase<SucceededState> {
  const SucceededState();

  /// @inhertdoc
  @override
  bool get isSucceeded => true;
}
