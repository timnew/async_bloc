import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/src/stated/base/unit_state_base.dart';
import 'package:stated_result/stated_result.dart';

class TestResult extends DoneState {
  TestResult();
}

void main() {
  group('CompletedResult', () {
    final result = TestResult();

    test("instance should be instance of UnitResultBase", () {
      expect(result, isInstanceOf<UnitStateBase<DoneState>>());
    });

    test("has correct state", () {
      expect(result.isIdle, isFalse);
      expect(result.isWorking, isFalse);
      expect(result.isSucceeded, isTrue);
      expect(result.isFailed, isFalse);
      expect(result.isFinished, isTrue);
      expect(result.hasValue, isFalse);
      expect(result.hasError, isFalse);
    });
  });
}
