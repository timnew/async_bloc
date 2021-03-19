import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/src/result/states/base/singleton_result_base.dart';
import 'package:stated_result/stated_result.dart';

class TestResult extends BusyResult {
  TestResult();
}

void main() {
  group('BusyResult', () {
    test("instance should be instance of SingletonResultBase", () {
      expect(TestResult(), isInstanceOf<SingletonResultBase<BusyResult>>());
    });
  });
}
