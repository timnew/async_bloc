import 'package:collection/collection.dart';

import '../stated.dart';

/// State indicates the action is failed with error
///
/// * [error] : exception or error object
/// * [stackTrace] : optional stack trace associated with error
class ErrorState with Stated implements HasError {
  /// Error or exception
  final Object error;

  /// Stack trace of the error
  final StackTrace? stackTrace;

  const ErrorState(this.error, [this.stackTrace]);
  ErrorState.fromError(HasError errorInfo)
      : this(errorInfo.error, errorInfo.stackTrace);

  @override
  bool operator ==(dynamic other) =>
      const IdentityEquality().equals(this, other) ||
      (other is ErrorState &&
          const IdentityEquality().equals(other.error, error) &&
          const IdentityEquality().equals(other.stackTrace, stackTrace));

  @override
  int get hashCode =>
      (ErrorState).hashCode ^
      const IdentityEquality().hash(error) ^
      const IdentityEquality().hash(stackTrace);

  @override
  String toString() => "FailedResult: $error\n$stackTrace";
}
