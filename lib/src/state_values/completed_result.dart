import 'result.dart';

abstract class CompletedResult with Result {
  const CompletedResult();

  @override
  bool operator ==(dynamic other) =>
      other is CompletedResult && other.runtimeType == runtimeType;

  @override
  int get hashCode => (CompletedResult).hashCode;

  @override
  String toString() => "CompletedResult";
}
