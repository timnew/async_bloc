import 'base/value_state_base.dart';

/// State indicates the action is completed successfully with value
class SucceededValueState<T> extends ValueStateBase<T, SucceededValueState<T>> {
  const SucceededValueState(T value) : super(value);

  /// @inhertdoc
  @override
  bool get isSucceeded => true;
}
