import '../multi_state_result.dart';

abstract class CompletedResult with MultiStateResult {
  const CompletedResult();

  @override
  bool operator ==(dynamic other) =>
      other is CompletedResult && other.runtimeType == runtimeType;

  @override
  int get hashCode => (CompletedResult).hashCode;

  @override
  String toString() => "CompletedResult";
}
