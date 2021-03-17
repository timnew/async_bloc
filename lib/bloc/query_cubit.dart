import 'dart:async';

import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../result.dart';

abstract class QueryCubit<T> extends Cubit<AsyncQueryResult<T>> {
  QueryCubit() : super(AsyncQueryResult());
  QueryCubit.initialValue(T intialValue)
      : super(AsyncQueryResult.withDefaultValue(intialValue));

  @protected
  Future<AsyncQueryResult<T>> flatMap(Future<QueryResult<T>> future) =>
      flatMapAsync(future.asAsyncResult());

  @protected
  Future<AsyncQueryResult<T>> flatMapAsync(
    Future<AsyncQueryResult<T>> future,
  ) async {
    this.state.ensureNotBusy();

    this.emit(AsyncQueryResult.busy());

    this.emit(await future);

    return this.state;
  }
}
