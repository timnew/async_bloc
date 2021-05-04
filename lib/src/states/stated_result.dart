import 'package:stated_result/src/states/results/waiting_value_result.dart';

import 'results/waiting_result.dart';
import 'results/completed_result.dart';
import 'results/initial_value_result.dart';
import 'results/failed_result.dart';
import 'results/pending_result.dart';
import 'results/succeeded_result.dart';

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

/// Contract for any state result with a value
///
/// Used by
/// * [SucceededResult]
/// * [InitialValueResult]
mixin ValueResult<T> implements StatedResult {
  /// The given value of the result
  T get value;
}

/// Error and its stack trace
mixin ErrorResult implements StatedResult {
  /// the exception or error
  Object get error;

  /// The stack trace of the error/exception
  StackTrace? get stackTrace;
}

/// Mapper function for general result state
typedef TR ResultMapper<TR>();

/// Mapper function for result state with value
typedef TR ValueResultMapper<T, TR>(ValueResult<T> result);

/// Mapper fucntion for result state has error
typedef TR FailedResultMapper<TR>(FailedResult result);

typedef TR ValueMapper<T, TR>(T value);
