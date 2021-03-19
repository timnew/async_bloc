import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/src/result/states/abstract/singleton_result_base.dart';
import 'package:stated_result/stated_result.dart';

class TestResult extends CompletedResult {
  TestResult();
}

void main() {
  group('CompletedResult', () {
    test("instance should be instance of StateLessResultBase", () {
      expect(
          TestResult(), isInstanceOf<StatelessResultBase<CompletedResult>>());
    });
  });
}
