import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/src/stated/states/base/unit_state_base.dart';
import 'package:stated_result/stated_result.dart';

class TestResult extends IdleState {
  TestResult();
}

void main() {
  group('PendingResult', () {
    final result = TestResult();

    test("instance should be instance of UnitResultBase", () {
      expect(result, isInstanceOf<UnitStateBase<IdleState>>());
    });

    test("has correct state", () {
      expect(result.isIdle, isTrue);
      expect(result.isWorking, isFalse);
      expect(result.isSucceeded, isFalse);
      expect(result.isFailed, isFalse);
      expect(result.isFinished, isFalse);
      expect(result.hasValue, isFalse);
      expect(result.hasError, isFalse);
    });
  });
}
