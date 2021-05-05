import 'package:stated_result/stated.dart';

abstract class StatedValue<T> implements Stated, HasValue<T> {
  const factory StatedValue.bestGuess(T value) = BestGuessValue;
  const factory StatedValue.Waiting(T value) = WaitingValue;
  const factory StatedValue.value(T value) = ConfirmedValue;
  const factory StatedValue.error(
    T value,
    Object error, [
    StackTrace? stackTrace,
  ]) = ErrorValue;

  BestGuessValue<T> toBestGuess() => BestGuessValue(value);
  WaitingValue<T> toWaiting() => WaitingValue(value);
  ConfirmedValue<T> toConfirmed() => ConfirmedValue(value);
  ErrorValue<T> toError(Object error, [StackTrace? stackTrace]) =>
      ErrorValue(value, error, stackTrace);

  StatedValue<T> setValue(T newValue);
  StatedValue<T> mapValue(ValueTransformer<T, T> mapper) =>
      setValue(mapper(value));

  TR map<TR>({
    required ValueTransformer<T, TR> bestGuess,
    required ValueTransformer<T, TR> waiting,
    required ValueTransformer<T, TR> confirmed,
    required ValueTransformer<HasValueAndError<T>, TR> error,
  }) {
    if (this is BestGuessValue) return bestGuess(value);
    if (this is WaitingValue) return waiting(value);
    if (this is ConfirmedValue) return confirmed(value);
    if (this is ErrorValue) return error(this as ErrorValue<T>);

    throw StateError("impossible branch");
  }

  TR consume<TR>({
    required ValueTransformer<T, TR> onValue,
    required ValueTransformer<HasError, TR> onError,
  }) =>
      this.hasError ? onError(this.asError()) : onValue(this.value);
}

class BestGuessValue<T> extends IdleValueState<T> with StatedValue<T> {
  const BestGuessValue(T value) : super(value);

  @override
  BestGuessValue<T> setValue(T newValue) => BestGuessValue(newValue);
}

class WaitingValue<T> extends WorkingValueState<T> with StatedValue<T> {
  const WaitingValue(T value) : super(value);

  @override
  WaitingValue<T> setValue(T newValue) => WaitingValue(value);
}

class ConfirmedValue<T> extends DoneValueState<T> with StatedValue<T> {
  const ConfirmedValue(T value) : super(value);

  @override
  ConfirmedValue<T> setValue(T newValue) => ConfirmedValue(value);
}

class ErrorValue<T> extends ErrorValueState<T> with StatedValue<T> {
  const ErrorValue(T value, Object error, [StackTrace? stackTrace])
      : super(value, error, stackTrace);

  @override
  ErrorValue<T> setValue(T newValue) => ErrorValue(value, error, stackTrace);
}
