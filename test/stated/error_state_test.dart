import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated.dart';

import '../custom_matchers.dart';

void main() {
  group("ErrorState", () {
    const error = "error";
    const state = ErrorState(error);

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
      expect(state, isInstanceOf<HasError>());
      expect(state, WithError(error));
    });

    test("its asError returns error info", () {
      expect(state.extractError(), error);
    });

    test("it should equals to each other", () {
      expect(state, ErrorState(error));
    });
  });
}
