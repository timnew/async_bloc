import 'base/value_result_base.dart';

abstract class WaitingValueResult<T>
    extends ValueResultBase<T, WaitingValueResult<T>> {
  const WaitingValueResult(T value) : super(value);
}
