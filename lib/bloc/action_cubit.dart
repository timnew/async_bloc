import 'dart:async';

import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../result.dart';

/// [Cubit] holds [AsyncActionResult]
abstract class ActionCubit extends Cubit<AsyncActionResult> {
  /// Create new Cubit
  ///
  /// Optional [initialState] can be used to set the initial state of the Cubit.
  /// [PendingResult] is used if not specified
  ActionCubit([AsyncActionResult? initialState])
      : super(initialState ?? AsyncActionResult());

  /// Update Cubit with a [Future] of any type
  /// [future] will be materialized first
  @protected
  Future<AsyncActionResult> updateWithGeneralFuture(Future future) =>
      updateWithAsyncResult(future.asActionResult().asAsyncResult());

  /// Update Cubit with a [Future] of [ActionResult]
  @protected
  Future<AsyncActionResult> updateWithResult(Future<ActionResult> future) =>
      updateWithAsyncResult(future.asAsyncResult());

  /// Update Cubit with a [Future] of [AsyncActionResult]
  @protected
  Future<AsyncActionResult> updateWithAsyncResult(
    Future<AsyncActionResult> future,
  ) async {
    this.state.ensureNotBusy();

    this.emit(AsyncActionResult.busy());

    this.emit(await future);

    return this.state;
  }
}
