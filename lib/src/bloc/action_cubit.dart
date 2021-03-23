import 'dart:async';

import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../stated_result.dart';

/// [Cubit] holds [AsyncActionResult]
abstract class ActionCubit extends Cubit<AsyncActionResult> {
  /// Create new Cubit
  ///
  /// Optional [initialState] can be used to set the initial state of the Cubit.
  /// [PendingResult] is used if not specified
  ActionCubit([AsyncActionResult? initialState])
      : super(initialState ?? AsyncActionResult());

  /// Capture the result of a generic aync action
  @protected
  Future<ActionResult> captureResult(Future future) =>
      updateWith(future.asActionResult());

  /// Update self with future [ActionResult]
  @protected
  Future<ActionResult> updateWith(Future<ActionResult> future) async {
    await state.updateWith(future).forEach(emit);

    return ActionResult.from(this.state);
  }
}
