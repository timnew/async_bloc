import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated.dart';

import '../custom_matchers.dart';

void main() {
  group("IdleValueState", () {
    const value = "value";
    const state = IdleValueState(value);

    test("it has correct state", () {
      expect(state.isIdle, isTrue);
      expect(state.isWorking, isFalse);
      expect(state.isFinished, isFalse);
      expect(state.isSucceeded, isFalse);
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
      expect(state, IdleValueState(value));
    });
  });
}
