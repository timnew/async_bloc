import 'package:flutter/foundation.dart';

import '../../stated_result.dart';

/// A [ValueNotifier] holds [AsyncActionResult]
class ActionResultNotifier extends ValueNotifier<AsyncActionResult> {
  /// Create new ValueNotifier
  ///
  /// Optional [initialState] can be used to set the initial state of the notifier.
  /// [PendingResult] is used if not specified
  ActionResultNotifier([AsyncActionResult? initialState])
      : super(initialState ?? AsyncActionResult());

  Future<AsyncActionResult> updateWithGeneralFuture(Future future) =>
      updateWithAsyncResult(future.asActionResult().asAsyncResult());

  /// Update [ValueNotifier] with a [Future] of [ActionResult]
  Future<AsyncActionResult> updateWithResult(Future<ActionResult> future) =>
      updateWithAsyncResult(future.asAsyncResult());

  /// Update [ValueNotifier] with a [Future] of [AsyncActionResult]
  Future<AsyncActionResult> updateWithAsyncResult(
    Future<AsyncActionResult> future,
  ) async {
    this.value.ensureNotBusy();

    this.value = AsyncActionResult.busy();

    this.value = await future;

    return this.value;
  }
}
