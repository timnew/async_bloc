import 'dart:async';

import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../result.dart';

abstract class ActionCubit extends Cubit<AsyncActionResult> {
  ActionCubit() : super(AsyncActionResult());

  @protected
  Future<AsyncActionResult> flatMap(FutureOr<ActionResult> futureOr) =>
      flatMapAsync(futureOr.asAsyncResult());

  @protected
  Future<AsyncActionResult> flatMapAsync(
    FutureOr<AsyncActionResult> futureOr,
  ) async {
    this.state.ensureNotBusy();

    this.emit(AsyncActionResult.busy());

    this.emit(await futureOr);

    return this.state;
  }
}
