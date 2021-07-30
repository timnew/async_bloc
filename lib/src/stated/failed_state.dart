import 'base/error_state_base.dart';

/// State indicates the action is failed with error
///
/// * [error] : exception or error object
class FailedState extends ErrorStateBase<FailedState> {
  /// Create [FailedState] from [error]
  const FailedState(Object error) : super(error);

  /// @inheritdoc
  @override
  bool get isFailed => true;
}
