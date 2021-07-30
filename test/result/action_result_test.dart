import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result.dart';

import '../custom_matchers.dart';
import '../states.dart';

void main() {
  group("ActionResult", () {
    group(".completed", () {
      final result = ActionResult.completed();

      test('should be a CompletedResult', () {
        expect(result, isInstanceOf<SucceededState>());
      });
      test('gives the same instance', () {
        expect(ActionResult.completed(), same(result));
      });

      test("should have correct states", () {
        expect(result.isIdle, isFalse);
        expect(result.isWorking, isFalse);
        expect(result.isFinished, isTrue);
        expect(result.isSucceeded, isTrue);
        expect(result.isFailed, isFalse);
        expect(result.hasValue, isFalse);
      });
    });

    group(".failed", () {
      final result = ActionResult.failed(error);

      test('should be a FailedResult', () {
        expect(result, isInstanceOf<FailedState>());
      });

      test('should contain error and stack trace', () {
        expect(result, WithError(error));
      });

      test("should have correct states", () {
        expect(result.isIdle, isFalse);
        expect(result.isWorking, isFalse);
        expect(result.isFinished, isTrue);
        expect(result.isSucceeded, isFalse);
        expect(result.isFailed, isTrue);
        expect(result.hasValue, isFalse);
        expect(result.extractError(), error);
      });
    });

    group(".from", () {
      test("idle", () {
        expect(() => ActionResult.from(idle), throwsUnsupportedError);
      });

      test("idleValue", () {
        expect(() => ActionResult.from(idleValue), throwsUnsupportedError);
      });

      test("working", () {
        expect(() => ActionResult.from(working), throwsUnsupportedError);
      });

      test("workingValue", () {
        expect(() => ActionResult.from(workingValue), throwsUnsupportedError);
      });

      test("error", () {
        final result = ActionResult.from(error);
        expect(result, isInstanceOf<ActionResult>());
        expect(result, isInstanceOf<FailedState>());
        expect(result, ActionResult.failed(exception));
      });

      test("errorValue", () {
        final result = ActionResult.from(errorValue);

        expect(result, isInstanceOf<ActionResult>());
        expect(result, isInstanceOf<FailedState>());
        expect(result, ActionResult.failed(exception));
      });

      test("done", () {
        final result = ActionResult.from(done);
        expect(result, isInstanceOf<ActionResult>());
        expect(result, isInstanceOf<SucceededState>());
      });

      test("doneValue", () {
        final result = ActionResult.from(doneValue);
        expect(result, isInstanceOf<ActionResult>());
        expect(result, isInstanceOf<SucceededState>());
      });
    });
  });

  group("ActionResultFutureExtension", () {
    group(".asActionResult()", () {
      group("Future<T>", () {
        test("runs", () async {
          final result = await Future.value(value).asActionResult();
          expect(result, isInstanceOf<ActionResult>());
          expect(result, isInstanceOf<SucceededState>());
        });

        test("yields error", () async {
          final result = Future.error(exception).asActionResult();
          await expectLater(result, completion(isInstanceOf<ActionResult>()));
          await expectLater(result, completion(isInstanceOf<FailedState>()));
          await expectLater(result, completion(WithError(exception)));
        });
      });

      group("Future<Stated>", () {
        test("yields IdleState", () async {
          final future = Future.value(IdleState());

          await expectLater(
            future.asActionResult(),
            throwsUnsupportedError,
          );
        });

        test("yields IdleValueState", () async {
          final future = Future.value(IdleValueState(value));

          await expectLater(
            future.asActionResult(),
            throwsUnsupportedError,
          );
        });

        test("yields WorkingState", () async {
          final future = Future.value(WorkingState());

          await expectLater(
            future.asActionResult(),
            throwsUnsupportedError,
          );
        });

        test("yields WorkingValueState", () async {
          final future = Future.value(WorkingValueState(value));

          await expectLater(
            future.asActionResult(),
            throwsUnsupportedError,
          );
        });

        test("yields DoneState", () async {
          final future = Future.value(SucceededState());

          await expectLater(
            future.asActionResult(),
            completion(isInstanceOf<ActionResult>()),
          );

          await expectLater(
            future.asActionResult(),
            completion(isInstanceOf<SucceededState>()),
          );
        });

        test("yields DoneValueState", () async {
          final future = Future.value(SucceededValueState(value));

          await expectLater(
            future.asActionResult(),
            completion(isInstanceOf<ActionResult>()),
          );

          await expectLater(
            future.asActionResult(),
            completion(isInstanceOf<SucceededState>()),
          );
        });

        test("yields ErrorState", () async {
          final future = Future.value(FailedState(exception));

          await expectLater(
            future.asActionResult(),
            completion(isInstanceOf<ActionResult>()),
          );

          await expectLater(
            future.asActionResult(),
            completion(isInstanceOf<FailedState>()),
          );

          await expectLater(
            future.asActionResult(),
            completion(WithError(exception)),
          );
        });

        test("yields ErrorValueState", () async {
          final future = Future.value(FailedValueState(value, exception));

          await expectLater(
            future.asActionResult(),
            completion(isInstanceOf<ActionResult>()),
          );

          await expectLater(
            future.asActionResult(),
            completion(isInstanceOf<FailedState>()),
          );

          await expectLater(
            future.asActionResult(),
            completion(WithError(exception)),
          );
        });
      });
    });
  });
}
