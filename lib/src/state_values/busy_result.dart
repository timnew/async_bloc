import 'multi_state_result.dart';

abstract class BusyResult with MultiStateResult {
  const BusyResult();

  @override
  bool operator ==(dynamic other) =>
      other is BusyResult && other.runtimeType == runtimeType;

  @override
  int get hashCode => (BusyResult).hashCode;

  @override
  String toString() => "BusyResult";
}
