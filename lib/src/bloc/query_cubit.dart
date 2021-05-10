import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stated_result/stated_result.dart';

/// [Cubit] holds [AsyncQueryResult]
class QueryCubit<T> extends Cubit<AsyncQueryResult<T>> {
  /// Create new Cubit
  ///
  /// Optional [initialState] can be used to set the initial state of the Cubit.
  /// [IdleState] is used if not specified
  QueryCubit([AsyncQueryResult<T>? initialState])
      : super(initialState ?? AsyncQueryResult());

  /// Create new Cubit with given intial value of the query
  /// [IdleValueState] will be set
  QueryCubit.initialValue(T intialValue)
      : super(AsyncQueryResult.preset(intialValue));

  /// Capture the result of a generic aync query
  Future<void> captureResult(Future<T> future) async {
    await state.updateWith(future, emit);
  }
}
