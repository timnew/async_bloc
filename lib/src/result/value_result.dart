import 'stated_result.dart';

/// Contract for any state result with a value
///
/// Used by
/// * [SucceededResult]
/// * [InitialValueResult]
abstract class ValueResult<T> implements StatedResult {
  /// The given value of the result
  T get value;
}
