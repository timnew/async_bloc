import '../../stated.dart';

/// Base class for state without any field
abstract class UnitStateBase<SELF extends Stated> with Stated {
  const UnitStateBase();

  @override
  bool operator ==(dynamic other) => other is SELF;

  @override
  int get hashCode => (SELF).hashCode;

  @override
  String toString() => (SELF).toString();
}
