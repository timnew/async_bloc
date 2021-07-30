import 'dart:async';

import 'package:stated_result/stated.dart';

import 'query_result.dart';
import 'async_action_result.dart';
import 'async_query_result.dart';

/// A type represents the result of an action.
///
/// [ActionResult.completed] creates the [DoneState], indicates the action is completed
/// [ActionResult.failed] creates the [ErrorState], indicates the action is failed
///
/// See also
/// * [AsyncActionResult]
/// * [QueryResult]
/// * [AsyncQueryResult]
abstract class ActionResult implements Stated {
  /// Alias to [ActionResult.completed]
  factory ActionResult() = ActionResult.completed;

  /// creates an [ActionResult] in [DoneState]
  /// This factory always returns a const result
  factory ActionResult.completed() => const _Completed();

  /// creates an [ActionResult] in [ErrorState] with [error]
  const factory ActionResult.failed(Object error) = _Failed;

  /// Create [ActionResult] from other [Stated] types
  /// * [DoneValueState] or [DoneState] converts to [ActionResult.completed]
  /// * [ErrorState] or [ErrorValueState] converts to [ActionResult.failed]
  ///  Otherwise [UnsupportedError] is thrown
  factory ActionResult.from(Stated other) {
    if (other.isSucceeded) return ActionResult.completed();
    if (other.isFailed) return ActionResult.failed(other.extractError());
    throw UnsupportedError("$other in the state not supported by ActionResult");
  }

  /// Pattern match the result
  ///
  /// [completed] is called if result is completed
  /// [failed] is called with error and stackTrace if result is failed
  TR map<TR>({
    required StateTransformer<TR> completed,
    required ValueTransformer<Object, TR> failed,
  }) {
    if (this is _Completed) return completed();
    return failed(this.extractError());
  }
}

class _Completed extends DoneState with ActionResult {
  const _Completed();
}

class _Failed extends ErrorState with ActionResult {
  const _Failed(Object error) : super(error);
}

/// Provides extension methods on `Future` for [ActionResult]
extension ActionResultFutureExtension on Future {
  /// Materialize `Future` into `Future<ActionResult>`]
  ///
  /// Materialised future always succeed unless future throws error
  /// Returns [ActionResult.completed] if future resovled succesfully
  /// Returns [ActionResult.failed] if future throws exception
  ///
  /// If future yields [Stated] type, the result is converted via [ActionResult.from]. If result in state that not supported, [StateError] is thrown
  /// Check [ActionResult.from] for more details.
  Future<ActionResult> asActionResult() async {
    final dynamic result;

    try {
      result = await this;
    } on Error {
      rethrow;
    } catch (exception) {
      return ActionResult.failed(exception);
    }

    if (result is Stated) {
      return ActionResult.from(result);
    }

    return ActionResult.completed();
  }
}
