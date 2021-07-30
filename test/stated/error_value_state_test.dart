import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated.dart';

import '../custom_matchers.dart';

void main() {
  group("ErrorValueState", () {
    const value = "value";
    const error = "error";
    const state = ErrorValueState(value, error);

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
      expect(state.extractValue(), value);
    });

    test("it has error info", () {
      expect(state, isInstanceOf<HasError>());
      expect(state, WithError(error));
    });

    test("its asError returns error info", () {
      expect(state.extractError(), error);
    });

    test("it should equals to each other", () {
      expect(state, ErrorValueState(value, error));
    });
  });
}
