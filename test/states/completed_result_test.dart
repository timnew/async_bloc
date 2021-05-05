import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/src/states/results/base/unit_result_base.dart';
import 'package:stated_result/stated_result.dart';

class TestResult extends CompletedResult {
  TestResult();
}

void main() {
  group('CompletedResult', () {
    final result = TestResult();

    test("instance should be instance of UnitResultBase", () {
      expect(result, isInstanceOf<UnitResultBase<CompletedResult>>());
    });

    test("has correct state", () {
      expect(result.isNotStarted, isFalse);
      expect(result.isWaiting, isFalse);
      expect(result.isSucceeded, isTrue);
      expect(result.isFailed, isFalse);
      expect(result.isFinished, isTrue);
      expect(result.hasValue, isFalse);
      expect(result.hasError, isFalse);
    });
  });
}
