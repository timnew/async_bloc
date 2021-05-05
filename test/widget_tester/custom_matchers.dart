import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result.dart';

class WithError extends CustomMatcher {
  WithError(Matcher matcher)
      : super("ErrorWithStack with error that is", "error", matcher);

  @override
  Object? featureValueOf(actual) => (actual as HasError).error;
}
