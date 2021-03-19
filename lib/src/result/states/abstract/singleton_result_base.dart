import '../../stated_result.dart';

/// Base class for state result without fields
abstract class StatelessResultBase<SELF extends StatedResult>
    with StatedResult {
  const StatelessResultBase();

  @override
  bool operator ==(dynamic other) => other is SELF;

  @override
  int get hashCode => (SELF).hashCode;

  @override
  String toString() => (SELF).toString();
}
