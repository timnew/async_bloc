import '../../multi_state_result.dart';

/// Base class for state result without fields
abstract class SingletonResultBase<SELF extends MultiStateResult>
    with MultiStateResult {
  const SingletonResultBase();

  @override
  bool operator ==(dynamic other) => other is SELF;

  @override
  int get hashCode => (SELF).hashCode;

  @override
  String toString() => (SELF).toString();
}
