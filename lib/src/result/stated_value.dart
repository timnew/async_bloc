import 'package:stated_result/src/states/results/failed_value_result.dart';
import 'package:stated_result/src/states/results/initial_value_result.dart';
import 'package:stated_result/src/states/results/waiting_value_result.dart';
import 'package:stated_result/stated_result.dart';

import '../states/stated_result.dart';

abstract class StateValue<T> implements StatedResult {
  const factory StateValue.bestGuess(T value) = _BestGuess;
  const factory StateValue.Waiting(T value) = _Waiting;
  const factory StateValue.value(T value) = _Value;
  const factory StateValue.error(T value, Object error,
      [StackTrace? stackTrace]) = _Error;
}

class _BestGuess<T> extends InitialValueResult with StateValue<T> {
  const _BestGuess(T value) : super(value);
}

class _Waiting<T> extends WaitingValueResult with StateValue<T> {
  const _Waiting(T value) : super(value);
}

class _Value<T> extends SucceededResult<T> with StateValue<T> {
  const _Value(T value) : super(value);
}

class _Error<T> extends FailedValueResult<T> with StateValue<T> {
  const _Error(T value, Object error, [StackTrace? stackTrace])
      : super(value, error, stackTrace);
}
