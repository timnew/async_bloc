import 'states/busy_result.dart';
import 'states/completed_result.dart';
import 'states/default_result.dart';
import 'states/failed_result.dart';
import 'states/pending_result.dart';
import 'states/value_result.dart';

mixin MultiStateResult {
  bool get isPending => this is PendingResult || this is DefaultResult;
  bool get isBusy => this is BusyResult;
  bool get isFinished => isSucceeded || isFailed;
  bool get isSucceeded => this is ValueResult || this is CompletedResult;
  bool get isFailed => this is FailedResult;
  bool get hasValue => this is HasValue;

  void ensureNotBusy() {
    if (this.isBusy) throw StateError("FlatMap is in progress");
  }
}

abstract class HasValue<T> {
  T get value;
}
