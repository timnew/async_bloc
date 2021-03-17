import 'result.dart';

abstract class PendingResult with Result {
  const PendingResult();

  @override
  bool operator ==(dynamic other) =>
      other is PendingResult && other.runtimeType == runtimeType;

  @override
  int get hashCode => (PendingResult).hashCode;

  @override
  String toString() => "PendingResult";
}
