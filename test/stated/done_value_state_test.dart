import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated.dart';

import '../custom_matchers.dart';

void main() {
  group("DoneValueState", () {
    const value = "value";
    const state = SucceededValueState(value);

    test("it has correct state", () {
      expect(state.isIdle, isFalse);
      expect(state.isWorking, isFalse);
      expect(state.isFinished, isTrue);
      expect(state.isSucceeded, isTrue);
      expect(state.isFailed, isFalse);
      expect(state.hasValue, isTrue);
      expect(state.hasError, isFalse);
    });

    test("it has value", () {
      expect(state, isInstanceOf<HasValue<String>>());
      expect(state, WithValue(value));
    });

    test("its asValue returns value", () {
      expect(state.extractValue(), value);
    });
    test("it should equals to each other", () {
      expect(state, SucceededValueState(value));
    });
  });
}
