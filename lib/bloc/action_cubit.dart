import 'dart:async';

import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../result.dart';

abstract class ActionCubit extends Cubit<AsyncActionResult> {
  ActionCubit() : super(AsyncActionResult());

  @protected
  Future<AsyncActionResult> flatMap(Future<ActionResult> future) =>
      flatMapAsync(future.asAsyncResult());

  @protected
  Future<AsyncActionResult> flatMapPlain(Future future) =>
      flatMapAsync(future.asActionResult().asAsyncResult());

  @protected
  Future<AsyncActionResult> flatMapAsync(
    Future<AsyncActionResult> future,
  ) async {
    this.state.ensureNotBusy();

    this.emit(AsyncActionResult.busy());

    this.emit(await future);

    return this.state;
  }
}
