import 'stated_result.dart';
import 'states/failed_result.dart';

/// Contract for any state result with a value
///
/// Used by
/// * [SucceededResult]
/// * [InitialValueResult]
abstract class ValueResult<T> implements StatedResult {
  /// The given value of the result
  T get value;
}

/// Mapper function for general result state
typedef TR ResultMapper<TR>();

/// Mapper function for result state with value
typedef TR ValueResultMapper<T, TR>(ValueResult<T> result);

/// Mapper fucntion for result state has error
typedef TR FailedResultMapper<TR>(FailedResult result);
