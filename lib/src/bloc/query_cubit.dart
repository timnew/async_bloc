import 'dart:async';

import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../stated_result.dart';

/// [Cubit] holds [AsyncQueryResult]
abstract class QueryCubit<T> extends Cubit<AsyncQueryResult<T>> {
  /// Create new Cubit
  ///
  /// Optional [initialState] can be used to set the initial state of the Cubit.
  /// [PendingResult] is used if not specified
  QueryCubit([AsyncQueryResult<T>? initialState])
      : super(initialState ?? AsyncQueryResult());

  /// Create new Cubit with given intial value of the query
  /// [InitialValueResult] will be set
  QueryCubit.initialValue(T intialValue)
      : super(AsyncQueryResult.initialValue(intialValue));

  /// Capture the result of a generic aync query
  @protected
  Future<QueryResult<T>> captureResult(Future<T> future) =>
      updateWith(future.asQueryResult());

  /// Update self with future [QueryResult]
  @protected
  Future<QueryResult<T>> updateWith(Future<QueryResult<T>> future) async {
    await state.updateWith(future).forEach(emit);

    return QueryResult<T>.from(this.state);
  }
}
