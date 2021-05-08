import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated.dart';

import '../custom_matchers.dart';

void main() {
  group("WorkingValueState", () {
    const value = "value";
    const state = WorkingValueState(value);

    test("it has correct state", () {
      expect(state.isIdle, isFalse);
      expect(state.isWorking, isTrue);
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
      expect(state.asValue(), value);
    });
    test("it should equals to each other", () {
      expect(state, WorkingValueState(value));
    });
  });
}
