import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/src/result/states/abstract/value_result_base.dart';
import 'package:stated_result/stated_result.dart';

class TestResult extends SucceededResult<String> {
  const TestResult(String value) : super(value);
}

void main() {
  group('SucceededResult', () {
    test("instance should be instance of ValueResultBase", () {
      expect(
        TestResult("value"),
        isInstanceOf<ValueResultBase<String, SucceededResult<String>>>(),
      );
    });
  });
}
