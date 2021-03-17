import 'result.dart';

abstract class BusyResult with Result {
  const BusyResult();

  @override
  bool operator ==(dynamic other) =>
      other is BusyResult && other.runtimeType == runtimeType;

  @override
  int get hashCode => (BusyResult).hashCode;

  @override
  String toString() => "BusyResult";
}
