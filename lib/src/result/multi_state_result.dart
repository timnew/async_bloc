import 'states/busy_result.dart';
import 'states/completed_result.dart';
import 'states/default_result.dart';
import 'states/failed_result.dart';
import 'states/pending_result.dart';
import 'states/value_result.dart';

/// Common behaviors for [ActionResult], [QueryResult], [AsyncActionResult], [AsyncQueryResult]
mixin MultiStateResult {
  /// Return true when query/action hasn't been started
  bool get isPending => this is PendingResult || this is DefaultResult;

  /// Return true when query/action is being processed
  bool get isBusy => this is BusyResult;

  /// Return true when query/action has been finished either with or without error
  bool get isFinished => isSucceeded || isFailed;

  /// Return true when query/action has finished successfully, regardless it is an action or query
  bool get isSucceeded => this is ValueResult || this is CompletedResult;

  /// Return ture when the query/action has finished with error
  bool get isFailed => this is FailedResult;

  /// Return true when query resut has a value, either it is intial value or the result after running query
  /// It also indicates whether state implemented the [HasValue] contract, regardless the type of the value
  bool get hasValue => this is HasValue;

  /// Ensure the query/action is not running
  /// Throw [StateError] if [isBusy] returns true
  ///
  /// Can be used as state check before kicking off new action/query to avoid parallel run
  void ensureNotBusy() {
    if (this.isBusy) throw StateError("Query/Action is in progress");
  }
}

/// Contract for any state result with a value
///
/// Used by
/// * [ValueResult]
/// * [DefaultResult]
abstract class HasValue<T> {
  /// The given value of the result
  T get value;
}
