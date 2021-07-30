import 'package:collection/collection.dart';

import '../stated.dart';

/// Base class for state implements [HasValue] contract
abstract class ErrorStateBase<SELF extends HasError>
    with Stated
    implements HasError {
  /// Error or exception
  final Object error;

  const ErrorStateBase(this.error);

  @override
  bool operator ==(dynamic other) =>
      const IdentityEquality().equals(this, other) ||
      (other is SELF && const IdentityEquality().equals(other.error, error));

  @override
  int get hashCode => (SELF).hashCode ^ const IdentityEquality().hash(error);

  @override
  String toString() => "$SELF($error)";
}
