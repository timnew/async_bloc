import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated.dart';

import '../custom_matchers.dart';

void main() {
  group("ErrorState", () {
    const error = "error";
    const stackTrace = StackTrace.empty;
    const state = ErrorState(error, stackTrace);

    test("it has correct state", () {
      expect(state.isIdle, isFalse);
      expect(state.isWorking, isFalse);
      expect(state.isFinished, isTrue);
      expect(state.isSucceeded, isFalse);
      expect(state.isFailed, isTrue);
      expect(state.hasValue, isFalse);
      expect(state.hasError, isTrue);
    });

    test("it has error info", () {
      expect(state, isInstanceOf<ErrorInfo>());
      expect(state, WithError(error));
      expect(state, WithStackTrace(stackTrace));
    });

    test("its asError returns error info", () {
      expect(state.asError(), WithError(error));
      expect(state.asError(), WithStackTrace(stackTrace));
    });

    test("it should equals to each other", () {
      expect(state, ErrorState(error, stackTrace));
    });
  });
}
