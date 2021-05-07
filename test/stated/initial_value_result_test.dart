import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/src/stated/states/base/value_state_base.dart';
import 'package:stated_result/stated_result.dart';

class TestResult extends IdleValueState<String> {
  const TestResult(String value) : super(value);
}

void main() {
  group('InitialValueResult', () {
    final value = "value";
    final result = TestResult(value);

    test("instance should be instance of ValueResultBase", () {
      expect(
        result,
        isInstanceOf<ValueStateBase<String, IdleValueState<String>>>(),
      );
    });

    test("has correct state", () {
      expect(result.isIdle, isTrue);
      expect(result.isWorking, isFalse);
      expect(result.isSucceeded, isFalse);
      expect(result.isFailed, isFalse);
      expect(result.isFinished, isFalse);
      expect(result.hasValue, isTrue);
      expect(result.asValue(), value);
      expect(result.hasError, isFalse);
    });
  });
}
