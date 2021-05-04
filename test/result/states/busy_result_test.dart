import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/src/states/results/base/unit_result_base.dart';
import 'package:stated_result/stated_result.dart';

class TestResult extends WaitingResult {
  TestResult();
}

void main() {
  group('WaitingResult', () {
    test("instance should be instance of UnitResultBase", () {
      expect(TestResult(), isInstanceOf<UnitResultBase<WaitingResult>>());
    });
  });
}
