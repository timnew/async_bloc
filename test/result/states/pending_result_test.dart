import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/src/result/states/abstract/unit_result_base.dart';
import 'package:stated_result/stated_result.dart';

class TestResult extends PendingResult {
  TestResult();
}

void main() {
  group('PendingResult', () {
    test("instance should be instance of UnitResultBase", () {
      expect(TestResult(), isInstanceOf<UnitResultBase<PendingResult>>());
    });
  });
}
