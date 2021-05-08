import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated.dart';

void main() {
  group("IdleState", () {
    const state = IdleState();

    test("it has correct state", () {
      expect(state.isIdle, isTrue);
      expect(state.isWorking, isFalse);
      expect(state.isFinished, isFalse);
      expect(state.isSucceeded, isFalse);
      expect(state.isFailed, isFalse);
      expect(state.hasValue, isFalse);
      expect(state.hasError, isFalse);
    });

    test("it should equals to each other", () {
      expect(state, IdleState());
    });
  });
}
