import 'package:collection/collection.dart';

import '../stated.dart';

/// Base class for state implements [HasValue] contract
abstract class ErrorStateBase<SELF extends ErrorInfo>
    with Stated
    implements ErrorInfo {
  /// Error or exception
  final Object error;

  /// Stack trace of the error
  final StackTrace? stackTrace;

  const ErrorStateBase(this.error, this.stackTrace);

  ErrorStateBase.fromError(ErrorInfo errorInfo)
      : this(errorInfo.error, errorInfo.stackTrace);

  @override
  bool operator ==(dynamic other) =>
      const IdentityEquality().equals(this, other) ||
      (other is SELF &&
          const IdentityEquality().equals(other.error, error) &&
          const IdentityEquality().equals(other.stackTrace, stackTrace));

  @override
  int get hashCode =>
      (SELF).hashCode ^
      const IdentityEquality().hash(error) ^
      const IdentityEquality().hash(stackTrace);

  @override
  String toString() => "$SELF($error)";
}
