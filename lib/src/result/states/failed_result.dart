import 'package:collection/collection.dart';

import '../contracts.dart';
import '../stated_result.dart';

/// State indicates the query/action is failed
///
/// [error] is the captured exception/error
/// [stackTrace] might be available indicates where the error was thrown
///
/// All states:
/// * [PendingResult]
/// * [WaitingResult]
/// * [InitialValueResult]
/// * [SucceededResult]
/// * [CompletedResult]
/// * [FailedResult]
///
/// Used by
/// * [ActionResult]
/// * [QueryResult]
/// * [AsyncActionResult]
/// * [AsyncQueryResult]
abstract class FailedResult with StatedResult implements ErrorWithStack {
  /// Error or exception caught
  final dynamic error;

  /// Stack trace of the error
  final StackTrace? stackTrace;

  const FailedResult(this.error, this.stackTrace);

  @override
  bool operator ==(dynamic other) =>
      const IdentityEquality().equals(this, other) ||
      (other is FailedResult &&
          const IdentityEquality().equals(other.error, error) &&
          const IdentityEquality().equals(other.stackTrace, stackTrace));

  @override
  int get hashCode =>
      (FailedResult).hashCode ^
      const IdentityEquality().hash(error) ^
      const IdentityEquality().hash(stackTrace);

  @override
  String toString() => "FailedResult: $error\n$stackTrace";
}
