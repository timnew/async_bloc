import 'package:collection/collection.dart';

import '../multi_state_result.dart';

abstract class FailedResult with MultiStateResult {
  final dynamic error;
  final StackTrace? stackTrace;

  const FailedResult(this.error, this.stackTrace);

  @override
  bool operator ==(dynamic other) =>
      const DeepCollectionEquality().equals(this, other) ||
      (other is FailedResult &&
          const DeepCollectionEquality().equals(other.error, error) &&
          const DeepCollectionEquality().equals(other.stackTrace, stackTrace));

  @override
  int get hashCode =>
      (FailedResult).hashCode ^
      const DeepCollectionEquality().hash(error) ^
      const DeepCollectionEquality().hash(stackTrace);

  @override
  String toString() => "FailedResult: $error\n$stackTrace";
}
