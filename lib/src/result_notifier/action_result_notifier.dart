import 'package:flutter/foundation.dart';

import '../../stated_result.dart';

/// A `ValueNotifier` holds [AsyncActionResult]
class ActionResultNotifier extends ValueNotifier<AsyncActionResult> {
  /// Create new ValueNotifier
  ///
  /// Optional [initialState] can be used to set the initial state of the notifier.
  /// [IdleState] is used if not specified
  ActionResultNotifier([AsyncActionResult? initialState])
      : super(initialState ?? AsyncActionResult());

  /// Capture the result of a generic async action
  Future<T> captureResult<T>(Future<T> future) {
    updateWith(future.asActionResult());
    return future;
  }

  /// Update self with future [ActionResult]
  Future<ActionResult> updateWith(Future<ActionResult> future) async {
    await value.updateWith(future).forEach((v) => this.value = v);

    return ActionResult.from(this.value);
  }
}
