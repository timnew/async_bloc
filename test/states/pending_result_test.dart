import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/src/states/results/base/unit_result_base.dart';
import 'package:stated_result/stated_result.dart';

class TestResult extends PendingResult {
  TestResult();
}

void main() {
  group('PendingResult', () {
    final result = TestResult();

    test("instance should be instance of UnitResultBase", () {
      expect(result, isInstanceOf<UnitResultBase<PendingResult>>());
    });

    test("has correct state", () {
      expect(result.isNotStarted, isTrue);
      expect(result.isWaiting, isFalse);
      expect(result.isSucceeded, isFalse);
      expect(result.isFailed, isFalse);
      expect(result.isFinished, isFalse);
      expect(result.hasValue, isFalse);
      expect(result.hasError, isFalse);
    });
  });
}
