import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stated_result/stated_result.dart';
import 'package:stated_result/internal.dart';

import 'stated_value.dart';

class StatedValueCubit<T> extends Cubit<StatedValue<T>> {
  StatedValueCubit(StatedValue<T> initialValue) : super(initialValue);

  T updateValue(ValueTransformer<T, T> updater) {
    final updated = this.state.mapValue(updater);
    emit(updated);
    return updated.value;
  }

  T setValue(T value) {
    emit(StatedValue.value(value));
    return value;
  }

  Future<T> setValueAsync(Future<T> asyncResult) async {
    state.ensureNoParallelRun();

    emit(state.toWaiting());
    try {
      final value = await asyncResult;
      emit(StatedValue.value(value));
      return value;
    } catch (error, stackTrace) {
      emit(state.toError(error, stackTrace));
      return state.value;
    }
  }

  Future<T> setValueWithGuess(T bestGuess, Future<T> asyncResult) async {
    state.ensureNoParallelRun();
    final oldValue = state.value;

    emit(StatedValue.bestGuess(bestGuess));
    try {
      final value = await asyncResult;
      emit(StatedValue.value(value));
      return value;
    } catch (error, stackTrace) {
      emit(StatedValue.error(oldValue, error, stackTrace));
      return oldValue;
    }
  }
}
