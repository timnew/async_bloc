import 'base/value_state_base.dart';

/// State indicates the action is in progress, with a value
class WorkingValueState<T> extends ValueStateBase<T, WorkingValueState<T>> {
  const WorkingValueState(T value) : super(value);
}
