import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated.dart';

void main() {
  group("WorkingState", () {
    const state = WorkingState();

    test("it has correct state", () {
      expect(state.isIdle, isFalse);
      expect(state.isWorking, isTrue);
      expect(state.isFinished, isFalse);
      expect(state.isSucceeded, isFalse);
      expect(state.isFailed, isFalse);
      expect(state.hasValue, isFalse);
      expect(state.hasError, isFalse);
    });

    test("it should equals to each other", () {
      expect(state, WorkingState());
    });
  });
}
