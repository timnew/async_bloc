import 'package:stated_result/stated_builder.dart';

/// State indicates the action is failed with error, and a value
///
/// * [error] : exception or error object
class ErrorValueState<T> extends ValueErrorStateBase<T, ErrorValueState<T>> {
  const ErrorValueState(T value, Object error) : super(value, error);
}
