import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_custom.dart';

class TestState extends UnitStateBase<TestState> {
  const TestState();
}

class TestValueState extends ValueStateBase<String, TestValueState> {
  const TestValueState(String value) : super(value);
}

class TestErrorState extends ErrorStateBase<TestErrorState> {
  const TestErrorState(Object error) : super(error);
}

class TestValueErrorState
    extends ValueErrorStateBase<String, TestValueErrorState> {
  const TestValueErrorState(String value, Object error) : super(value, error);
}

void main() {
  group("OnState", () {
    final value = "value";
    final error = Error();

    final testState = TestState();
    final testValueState = TestValueState(value);
    final testErrorState = TestErrorState(error);
    final testValueErrorState = TestValueErrorState(value, error);

    final idleState = IdleState();
    final idleValueState = IdleValueState(value);
    final workingState = WorkingState();
    final workingValueState = WorkingValueState(value);
    final errorState = FailedState(error);
    final errorValueState = FailedValueState(error, value);
    final doneState = SucceededState();
    final doneValueState = SucceededValueState(value);

    void runTest(Map<OnState, bool> patterns,
        {required List<Stated> matches, required List<Stated> doesNotMatch}) {
      matches.forEach((state) {
        test("matches $state", () {
          expect(state.matchPattern(patterns), isTrue);
        });
      });

      doesNotMatch.forEach((state) {
        test("does not match $state", () {
          expect(() => state.matchPattern(patterns), throwsStateError);
        });
      });
    }

    group("empty pattern", () {
      runTest(
        {},
        matches: [],
        doesNotMatch: [
          testState,
          testValueState,
          testErrorState,
          testValueErrorState,
          idleState,
          idleValueState,
          workingState,
          workingValueState,
          errorState,
          errorValueState,
          doneState,
          doneValueState,
        ],
      );
    });

    group("predefined", () {
      group(".always", () {
        runTest(
          {OnState.always(): true},
          matches: [
            testState,
            testValueState,
            testErrorState,
            testValueErrorState,
            idleState,
            idleValueState,
            workingState,
            workingValueState,
            errorState,
            errorValueState,
            doneState,
            doneValueState,
          ],
          doesNotMatch: [],
        );
      });

      group(".isIdle", () {
        runTest(
          {OnState.isIdle(): true},
          matches: [
            idleState,
            idleValueState,
          ],
          doesNotMatch: [
            testState,
            testValueState,
            testErrorState,
            testValueErrorState,
            workingState,
            workingValueState,
            errorState,
            errorValueState,
            doneState,
            doneValueState,
          ],
        );
      });

      group(".isWorking", () {
        runTest(
          {OnState.isWorking(): true},
          matches: [
            workingState,
            workingValueState,
          ],
          doesNotMatch: [
            testState,
            testValueState,
            testErrorState,
            testValueErrorState,
            idleState,
            idleValueState,
            errorState,
            errorValueState,
            doneState,
            doneValueState,
          ],
        );
      });

      group(".isFailed", () {
        runTest(
          {OnState.isFailed(): true},
          matches: [
            errorState,
            errorValueState,
          ],
          doesNotMatch: [
            testState,
            testValueState,
            testErrorState,
            testValueErrorState,
            idleState,
            idleValueState,
            workingState,
            workingValueState,
            doneState,
            doneValueState,
          ],
        );
      });

      group(".isSuceeded", () {
        runTest(
          {OnState.isSuceeded(): true},
          matches: [
            doneState,
            doneValueState,
          ],
          doesNotMatch: [
            testState,
            testValueState,
            testErrorState,
            testValueErrorState,
            idleState,
            idleValueState,
            workingState,
            workingValueState,
            errorState,
            errorValueState,
          ],
        );
      });

      group(".isFinished", () {
        runTest(
          {OnState.isFinished(): true},
          matches: [
            errorState,
            errorValueState,
            doneState,
            doneValueState,
          ],
          doesNotMatch: [
            testState,
            testValueState,
            testErrorState,
            testValueErrorState,
            idleState,
            idleValueState,
            workingState,
            workingValueState,
          ],
        );
      });

      group(".hasValue", () {
        runTest(
          {OnState.hasValue(): true},
          matches: [
            testValueState,
            testValueErrorState,
            idleValueState,
            workingValueState,
            errorValueState,
            doneValueState,
          ],
          doesNotMatch: [
            testState,
            testErrorState,
            idleState,
            workingState,
            errorState,
            doneState,
          ],
        );
      });

      group(".hasError", () {
        runTest(
          {OnState.hasError(): true},
          matches: [
            testErrorState,
            testValueErrorState,
            errorState,
            errorValueState,
          ],
          doesNotMatch: [
            testState,
            testValueState,
            idleState,
            idleValueState,
            workingState,
            workingValueState,
            doneState,
            doneValueState,
          ],
        );
      });

      group(".hasValueAndError", () {
        runTest(
          {OnState.hasValueAndError(): true},
          matches: [
            testValueErrorState,
            errorValueState,
          ],
          doesNotMatch: [
            testState,
            testValueState,
            testErrorState,
            idleState,
            idleValueState,
            workingState,
            workingValueState,
            errorState,
            doneState,
            doneValueState,
          ],
        );
      });
    });
  });
}
