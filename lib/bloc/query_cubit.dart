import 'dart:async';

import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../result.dart';

abstract class QueryCubit<T> extends Cubit<AsyncQueryResult<T>> {
  QueryCubit() : super(AsyncQueryResult());
  QueryCubit.initialValue(T intialValue)
      : super(AsyncQueryResult.initialValue(intialValue));

  /// Update Cubit with a [Future]
  /// [future] will be materialized first
  @protected
  Future<AsyncQueryResult<T>> updateWithQueryFuture(Future<T> future) =>
      updateWithAsyncResult(future.asQueryResult().asAsyncResult());

  /// Update Cubit with a [Future] of [QueryResultd]
  @protected
  Future<AsyncQueryResult<T>> updateWithResult(Future<QueryResult<T>> future) =>
      updateWithAsyncResult(future.asAsyncResult());

  /// Update Cubit with a [Future] of [AsyncQueryResult]
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
