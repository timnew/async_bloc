import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result.dart';

class HasError extends CustomMatcher {
  HasError(Matcher matcher)
      : super("ErrorWithStack with error that is", "error", matcher);

  @override
  Object? featureValueOf(actual) => (actual as ErrorWithStack).error;
}
