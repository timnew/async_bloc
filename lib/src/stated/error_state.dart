import 'base/error_state_base.dart';
import 'stated.dart';

/// State indicates the action is failed with error
///
/// * [error] : exception or error object
/// * [stackTrace] : optional stack trace associated with error
class ErrorState extends ErrorStateBase<ErrorState> {
  /// Create [ErrorState] from [error] and [stackTrace]
  const ErrorState(Object error, [StackTrace? stackTrace])
      : super(error, stackTrace);

  /// CreateError from another [ErrorInfo]
  ErrorState.fromError(ErrorInfo errorInfo) : super.fromError(errorInfo);
}
