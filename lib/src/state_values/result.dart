import 'busy_result.dart';
import 'completed_result.dart';
import 'default_result.dart';
import 'failed_result.dart';
import 'pending_result.dart';
import 'value_result.dart';

mixin Result {
  bool get isPending => this is PendingResult || this is DefaultResult;
  bool get isBusy => this is BusyResult;
  bool get isFinished => isSucceeded || isFailed;
  bool get isSucceeded => this is ValueResult || this is CompletedResult;
  bool get isFailed => this is FailedResult;
  bool get hasValue => this is HasValue;
}

abstract class HasValue<T> {
  T get value;
}
