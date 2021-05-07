import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/src/stated/base/value_state_base.dart';
import 'package:stated_result/stated_result.dart';

class TestResult extends DoneValueState<String> {
  const TestResult(String value) : super(value);
}

void main() {
  group('SucceededResult', () {
    final value = "value";
    final result = TestResult(value);

    test("instance should be instance of ValueResultBase", () {
      expect(
        TestResult("value"),
        isInstanceOf<ValueStateBase<String, DoneValueState<String>>>(),
      );
    });

    test("has correct state", () {
      expect(result.isIdle, isFalse);
      expect(result.isWorking, isFalse);
      expect(result.isSucceeded, isTrue);
      expect(result.isFailed, isFalse);
      expect(result.isFinished, isTrue);
      expect(result.hasValue, isTrue);
      expect(result.asValue(), value);
      expect(result.hasError, isFalse);
    });
  });
}
