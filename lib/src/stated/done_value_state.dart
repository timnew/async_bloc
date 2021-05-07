import 'base/value_state_base.dart';

/// State indicates the action is completed successfully with value
class DoneValueState<T> extends ValueStateBase<T, DoneValueState<T>> {
  const DoneValueState(T value) : super(value);
}
