import 'base/error_state_base.dart';

/// State indicates the action is failed with error
///
/// * [error] : exception or error object
class ErrorState extends ErrorStateBase<ErrorState> {
  /// Create [ErrorState] from [error]
  const ErrorState(Object error) : super(error);
}
