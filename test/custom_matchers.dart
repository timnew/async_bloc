import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated.dart';

class HasError extends CustomMatcher {
  HasError(dynamic matcher)
      : super("HasError with error that is", "error", matcher);

  @override
  Object? featureValueOf(actual) => (actual as ErrorInfo).error;
}

class HasStackTrace extends CustomMatcher {
  HasStackTrace(dynamic matcher)
      : super("HasError with stackTrace that is", "stackTrace", matcher);

  @override
  Object? featureValueOf(actual) => (actual as ErrorInfo).stackTrace;
}
