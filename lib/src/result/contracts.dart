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

/// Error and its stack trace
abstract class ErrorWithStack {
  /// the exception or error
  dynamic get error;

  /// The stack trace of the error/exception
  StackTrace? get stackTrace;

  /// Create an instance
  const factory ErrorWithStack(dynamic error, [StackTrace? stackTrace]) =
      _ErrorWithStack;
}

/// Generic implementation of [ErrorWithStack]
class _ErrorWithStack extends FailedResult {
  const _ErrorWithStack(error, [StackTrace? stackTrace])
      : super(error, stackTrace);
}

/// Mapper function for general result state
typedef TR ResultMapper<TR>();

/// Mapper function for result state with value
typedef TR ValueResultMapper<T, TR>(ValueResult<T> result);

/// Mapper fucntion for result state has error
typedef TR FailedResultMapper<TR>(FailedResult result);

typedef TR ValueMapper<T, TR>(T value);
