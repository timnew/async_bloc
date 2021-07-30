import 'base/value_state_base.dart';

/// State indicates the action haven't started yet, with a value
class IdleValueState<T> extends ValueStateBase<T, IdleValueState<T>> {
  const IdleValueState(T value) : super(value);

  /// @inheritdoc
  @override
  bool get isIdle => true;
}
