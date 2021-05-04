import 'package:stated_result/src/result/states/waiting_value_resut.dart';

import 'contracts.dart';
import 'states/waiting_result.dart';
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
  bool get isWaiting => this is WaitingResult || this is WaitingValueResult;

  /// Return true when query/action has been finished either with or without error
  bool get isFinished => isSucceeded || isFailed;

  /// Return true when query/action has finished successfully, regardless it is an action or query
  bool get isSucceeded => this is SucceededResult || this is CompletedResult;

  /// Return ture when the query/action has finished with error
  bool get isFailed => this is FailedResult;

  /// Check if result holds a value. If returns true, it is can be converted into a [ValueResult].
  bool get hasValue => this is ValueResult;

  /// Check if result holds a error, If reurns true, it is safe to call [asError].
  bool get hasError => this is ErrorResult;

  ErrorResult asError() => this as ErrorResult;
  ValueResult<T> asValue<T>() => this as ValueResult<T>;
}
