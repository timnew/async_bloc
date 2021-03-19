import 'package:stated_result/src/result/value_result.dart';

import 'states/busy_result.dart';
import 'states/completed_result.dart';
import 'states/initial_value_result.dart';
import 'states/failed_result.dart';
import 'states/pending_result.dart';
import 'states/succeeded_result.dart';

/// Common behaviors for [ActionResult], [QueryResult], [AsyncActionResult], [AsyncQueryResult]
mixin StatedResult {
  /// Return true when query/action hasn't been started
  bool get isNotStarted => this is PendingResult || this is InitialValueResult;

  /// Return true when query/action is being processed
  bool get isBusy => this is BusyResult;

  /// Return true when query/action has been finished either with or without error
  bool get isFinished => isSucceeded || isFailed;

  /// Return true when query/action has finished successfully, regardless it is an action or query
  bool get isSucceeded => this is SucceededResult || this is CompletedResult;

  /// Return ture when the query/action has finished with error
  bool get isFailed => this is FailedResult;

  /// Return true when query resut has a value, either it is intial value or the result after running query
  /// It also indicates whether state implemented the [ValueResult] contract, regardless the type of the value
  bool get hasValue => this is ValueResult;

  /// Ensure no trigger parallel running
  /// Throw [StateError] if [isBusy] returns true
  ///
  /// Can be used as state check before kicking off new action/query to avoid parallel run
  void ensureNoParallelRun() {
    if (this.isBusy) throw StateError("Parallel run");
  }

  FailedResult? asFailed() => isFailed ? this as FailedResult : null;
  ValueResult<T>? asValueResult<T>() =>
      this is ValueResult<T> ? this as ValueResult<T> : null;
}
