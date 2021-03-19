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
  /// [DefaultResult] will be set
  QueryCubit.initialValue(T intialValue)
      : super(AsyncQueryResult.initialValue(intialValue));

  /// Update Cubit with a `Future`
  /// `Future` will be materialized first
  @protected
  Future<AsyncQueryResult<T>> updateWithQueryFuture(Future<T> future) =>
      updateWithAsyncResult(future.asQueryResult().asAsyncResult());

  /// Update Cubit with a `Future` of [QueryResultd]
  @protected
  Future<AsyncQueryResult<T>> updateWithResult(Future<QueryResult<T>> future) =>
      updateWithAsyncResult(future.asAsyncResult());

  /// Update Cubit with a `Future` of [AsyncQueryResult]
  @protected
  Future<AsyncQueryResult<T>> updateWithAsyncResult(
    Future<AsyncQueryResult<T>> future,
  ) async {
    this.state.ensureNotBusy();

    this.emit(AsyncQueryResult.busy());

    this.emit(await future);

    return this.state;
  }
}
