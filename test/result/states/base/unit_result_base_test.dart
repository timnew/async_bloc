import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/src/states/stated_result.dart';
import 'package:stated_result/src/states/results/base/unit_result_base.dart';

class TestState extends UnitResultBase<TestState> {
  const TestState();
}

class TestResult extends TestState {
  TestResult();
}

class AnotherTestResult extends TestState {
  const AnotherTestResult();
}

void main() {
  group('UnitResultBase', () {
    final result1 = TestResult();
    final result2 = TestResult();
    final anotherResult = const AnotherTestResult();

    test("all non singleton instances should equal to each other", () {
      expect(result1, isNot(same(result2)));

      expect(result1, result2);
      expect(result1.hashCode, result2.hashCode);
    });

    test(
        "instance of dervied class should be equal even if they are different type",
        () {
      expect(result1, anotherResult);
      expect(result1.hashCode, anotherResult.hashCode);
    });

    test("derived class can have const constructor", () {
      expect(anotherResult, same(const AnotherTestResult()));
    });

    test("instances should be instance of MultiStateResult", () {
      expect(result1, isInstanceOf<StatedResult>());
      expect(anotherResult, isInstanceOf<StatedResult>());
    });

    test("toString() should get State name", () {
      expect(result1.toString(), "TestState");
      expect(anotherResult.toString(), "TestState");
    });
  });
}
