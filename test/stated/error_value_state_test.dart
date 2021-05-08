import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated.dart';

import '../custom_matchers.dart';

void main() {
  group("ErrorValueState", () {
    const value = "value";
    const error = "error";
    const stackTrace = StackTrace.empty;
    const state = ErrorValueState(value, error, stackTrace);

    test("it has correct state", () {
      expect(state.isIdle, isFalse);
      expect(state.isWorking, isFalse);
      expect(state.isFinished, isTrue);
      expect(state.isSucceeded, isFalse);
      expect(state.isFailed, isTrue);
      expect(state.hasValue, isTrue);
      expect(state.hasError, isTrue);
    });

    test("it has value", () {
      expect(state, isInstanceOf<HasValue<String>>());
      expect(state, WithValue(value));
    });

    test("its asValue returns value", () {
      expect(state.asValue(), value);
    });

    test("it has error info", () {
      expect(state, isInstanceOf<ErrorInfo>());
      expect(state, WithError(error));
      expect(state, WithStackTrace(stackTrace));
    });

    test("its asError returns error info", () {
      expect(state.asError(), WithError(error));
      expect(state.asError(), WithStackTrace(stackTrace));
    });
    test("it should equals to each other", () {
      expect(state, ErrorValueState(value, error, stackTrace));
    });
  });
}
