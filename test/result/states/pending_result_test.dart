import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/src/result/states/base/singleton_result_base.dart';
import 'package:stated_result/stated_result.dart';

class TestResult extends PendingResult {
  TestResult();
}

void main() {
  group('PendingResult', () {
    test("instance should be instance of SingletonResultBase", () {
      expect(TestResult(), isInstanceOf<SingletonResultBase<PendingResult>>());
    });
  });
}
