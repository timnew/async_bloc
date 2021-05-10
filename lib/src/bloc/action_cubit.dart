import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stated_result/stated_result.dart';

/// [Cubit] holds [AsyncActionResult]
class ActionCubit extends Cubit<AsyncActionResult> {
  /// Create new Cubit
  ///
  /// Optional [initialState] can be used to set the initial state of the Cubit.
  /// [IdleState] is used if not specified
  ActionCubit([AsyncActionResult? initialState])
      : super(initialState ?? AsyncActionResult.idle());

  /// Capture the result of a generic aync action
  Future<void> captureResult<T>(Future<T> future) async {
    await this.state.updateWith(future, emit);
  }
}
