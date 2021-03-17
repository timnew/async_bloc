import 'dart:async';

import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../result.dart';

abstract class QueryCubit<T> extends Cubit<AsyncQueryResult<T>> {
  QueryCubit() : super(const AsyncQueryResult());
  QueryCubit.initialValue(T intialValue)
      : super(AsyncQueryResult.withDefaultValue(intialValue));

  @protected
  Future<AsyncQueryResult<T>> flatMap(FutureOr<QueryResult<T>> futureOr) =>
      flatMapAsync(futureOr.asAsyncResult());

  @protected
  Future<AsyncQueryResult<T>> flatMapAsync(
    FutureOr<AsyncQueryResult<T>> futureOr,
  ) async {
    this.state.ensureNotBusy();

    this.emit(AsyncQueryResult.busy());

    this.emit(await futureOr);

    return this.state;
  }
}
