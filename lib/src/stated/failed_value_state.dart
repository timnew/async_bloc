import 'package:stated_result/stated_builder.dart';

/// State indicates the action is failed with error, and a value
///
/// * [error] : exception or error object
class FailedValueState<T> extends ValueErrorStateBase<T, FailedValueState<T>> {
  const FailedValueState(T value, Object error) : super(value, error);

  /// @inheritdoc
  @override
  bool get isFailed => true;
}
