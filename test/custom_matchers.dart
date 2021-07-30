import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated.dart';

class WithError extends CustomMatcher {
  WithError(dynamic matcher)
      : super("HasError with error that is", "error", matcher);

  @override
  Object? featureValueOf(actual) => (actual as HasError).error;
}

class WithValue extends CustomMatcher {
  WithValue(dynamic matcher)
      : super("HasValue with value that is", "value", matcher);

  @override
  Object? featureValueOf(actual) => (actual as HasValue).value;
}
