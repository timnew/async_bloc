import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/src/stated/states/base/unit_state_base.dart';
import 'package:stated_result/stated_result.dart';

class TestResult extends WaitingState {
  TestResult();
}

void main() {
  group('WaitingResult', () {
    final result = TestResult();

    test("instance should be instance of UnitResultBase", () {
      expect(result, isInstanceOf<UnitStateBase<WaitingState>>());
    });

    test("has correct state", () {
      expect(result.isIdle, isFalse);
      expect(result.isWaiting, isTrue);
      expect(result.isSucceeded, isFalse);
      expect(result.isFailed, isFalse);
      expect(result.isFinished, isFalse);
      expect(result.hasValue, isFalse);
      expect(result.hasError, isFalse);
    });
  });
}
