import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/src/result/multi_state_result.dart';
import 'package:stated_result/src/result/states/base/singleton_result_base.dart';

class TestState extends SingletonResultBase<TestState> {
  const TestState();
}

class TestResult extends TestState {
  TestResult();
}

class AnotherTestResult extends TestState {
  const AnotherTestResult();
}

void main() {
  group('SingletonResultBase', () {
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
      expect(result1, isInstanceOf<MultiStateResult>());
      expect(anotherResult, isInstanceOf<MultiStateResult>());
    });

    test("toString() should get State name", () {
      expect(result1.toString(), "TestState");
      expect(anotherResult.toString(), "TestState");
    });
  });
}
