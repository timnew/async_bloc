import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/src/result/stated_result.dart';
import 'package:stated_result/src/result/states/base/value_result_base.dart';

class TestValueResult extends ValueResultBase<String, TestValueResult> {
  const TestValueResult(String value) : super(value);
}

class TestResult extends TestValueResult {
  const TestResult(String value) : super(value);
}

class AnotherTestResult extends TestValueResult {
  const AnotherTestResult(String value) : super(value);
}

class DifferentTestValueResult
    extends ValueResultBase<String, DifferentTestValueResult> {
  const DifferentTestValueResult(String value) : super(value);
}

class DifferentResult extends DifferentTestValueResult {
  const DifferentResult(String value) : super(value);
}

void main() {
  group('ValueResultBase', () {
    final value1 = "value1";
    final value2 = "value2";

    test("Result with same value should equal to each other", () {
      final result1 = TestResult(value1);
      final result2 = TestResult(value1);

      expect(result1, isNot(same(result2)));

      expect(result1, result2);
      expect(result1.hashCode, result2.hashCode);
    });

    test("Result with different value should not equal to each other", () {
      final result1 = TestResult(value1);
      final result2 = TestResult(value2);

      expect(result1, isNot(equals(result2)));
      expect(result1.hashCode, isNot(equals(result2.hashCode)));
    });

    test("Result with same value but different type should equal to each other",
        () {
      final result1 = TestResult(value1);
      final result2 = AnotherTestResult(value1);

      expect(result1, result2);
      expect(result1.hashCode, result2.hashCode);
    });

    test(
        "Result with same value but with different state should not equal to each other",
        () {
      final result1 = TestResult(value1);
      final result2 = DifferentResult(value1);

      expect(result1, isNot(equals(result2)));
      expect(result1.hashCode, isNot(equals(result2.hashCode)));
    });

    test("derived class can have const constructor", () {
      expect(const TestResult("value"), same(const TestResult("value")));
    });

    test("instances should be instance of MultiStateResult", () {
      expect(TestResult(value1), isInstanceOf<StatedResult>());
      expect(AnotherTestResult(value2), isInstanceOf<StatedResult>());
    });

    test("instances should be instance of HasValue", () {
      expect(TestResult(value1), isInstanceOf<HasValue<String>>());
      expect(AnotherTestResult(value2), isInstanceOf<HasValue<String>>());
    });

    test("toString() should contains State name and value", () {
      expect(TestResult(value1).toString(), "TestValueResult<String>: value1");
      expect(TestResult(value1).toString(), "TestValueResult<String>: value1");
      expect(DifferentResult(value1).toString(),
          "DifferentTestValueResult<String>: value1");
    });
  });
}
